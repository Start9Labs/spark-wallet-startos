import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
   "tor-address": {
      "name": "Main Tor Address",
      "description": "The Tor address for the main interface.",
      "type": "pointer",
      "subtype": "package",
      "package-id": "spark-wallet",
      "target": "tor-address",
      "interface": "main"
   },
   "user": {
      "type": "string",
      "name": "Username",
      "description": "Username for logging in to Spark",
      "nullable": false,
      "pattern": "^[^\\n:]+$",
      "pattern-description": "May not contain newline or \":\"",
      "copyable": true,
      "default": "spark"
   },
   "password": {
      "type": "string",
      "name": "Password",
      "description": "Password for logging in to Spark",
      "nullable": false,
      "pattern": "^[^\\n:]+$",
      "pattern-description": "May not contain newline or \":\"",
      "copyable": true,
      "masked": true,
      "default": {
         "charset": "a-z,A-Z,0-9",
         "len": 22
      }
   }
});
