use std::fs::File;
use std::io::Write;
use std::path::Path;

#[derive(serde::Deserialize)]
#[serde(rename_all = "kebab-case")]
struct Config {
    user: String,
    password: String,
}

#[derive(serde::Serialize)]
pub struct Properties {
    version: u8,
    data: Data,
}

#[derive(serde::Serialize)]
pub struct Data {
    #[serde(rename = "Pairing URL")]
    pairing_url: Property<String>,
}

#[derive(serde::Serialize)]
pub struct Property<T> {
    #[serde(rename = "type")]
    value_type: &'static str,
    value: T,
    description: Option<String>,
    copyable: bool,
    qr: bool,
    masked: bool,
}

fn main() -> Result<(), anyhow::Error> {
    let config: Config =
        serde_yaml::from_reader(File::open("/root/.spark-wallet/start9/config.yaml")?)?;
    let tor_address = std::env::var("TOR_ADDRESS")?;
    {
        let mut outfile = File::create("/root/.spark-wallet/config")?;

        write!(
            outfile,
            include_str!("config.template"),
            user = config.user,
            password = config.password,
            tor_address = tor_address,
        )?;
    }
    #[cfg(target_os = "linux")]
    nix::unistd::daemon(true, true)?;
    let cookie_path = Path::new("/root/.spark-wallet/cookie");
    while !cookie_path.exists() {
        std::thread::sleep(std::time::Duration::from_secs(1));
    }
    let cookie = std::fs::read_to_string(cookie_path)?;
    serde_yaml::to_writer(
        File::create("/root/.spark-wallet/start9/stats.yaml")?,
        &Properties {
            version: 2,
            data: Data {
                pairing_url: Property {
                    value_type: "string",
                    value: format!(
                        "http://{tor_address}:80/?access-key={access_key}",
                        tor_address = tor_address,
                        access_key = cookie
                            .split(":")
                            .skip(2)
                            .next()
                            .ok_or_else(|| anyhow::anyhow!("invalid cookie"))?,
                    ),
                    description: Some(
                        "Scan this with the Spark Wallet Mobile App to connect".to_owned(),
                    ),
                    copyable: true,
                    qr: true,
                    masked: true,
                },
            },
        },
    )?;
    Ok(())
}
