import { types as T, matches, util } from "../deps.ts";
import { getConfig } from "./getConfig.ts";

export const health: T.ExpectedExports.health = {
  // deno-lint-ignore require-await
  async "web"(effects, duration) {
    return healthWeb(effects, duration);
  },
  // deno-lint-ignore require-await
  async "user-signups-off"(effects, duration) {
    return healthSignups(effects, duration);
  },
};

const healthWeb: T.ExpectedExports.health[""] = async (effects, duration) => {
  await guardDurationAboveMinimum({ duration, minimumTime: 5000 });

  return await effects.fetch("http://gitea.embassy:3000")
    .then((_) => ok)
    .catch((e) => {
      effects.error(`${e}`)
      return error(`The Gitea UI is unreachable`)
    });
};

const healthSignups: T.ExpectedExports.health[""] = async (effects, duration) => {
  await guardDurationAboveMinimum({ duration, minimumTime: 5000 });
  const config = (util.unwrapResultType(await getConfig(effects))).config!
  if (!matchRegistration.test(config)) {
    throw `Could not find "disable-registration" key in config: ${matchRegistration.errorMessage(config)}`
  }
  if (!config['disable-registration']) {
    return error("For security purposes, user account registration should be disabled when not in use. You can disable registration in Config settings.")
  }
  return ok
}

// *** HELPER FUNCTIONS *** //

const { shape, boolean } = matches
const matchRegistration = shape({
  'disable-registration': boolean
})

// Ensure the starting duration is past a minimum
const guardDurationAboveMinimum = (
  input: { duration: number; minimumTime: number },
) =>
  (input.duration <= input.minimumTime)
    ? Promise.reject(errorCode(60, "Starting"))
    : null;

const errorCode = (code: number, error: string) => ({
  "error-code": [code, error] as const,
});
const error = (error: string) => ({ error });
const ok = { result: null };
