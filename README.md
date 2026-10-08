# eModely Engine for Claude

Simulate chiller plants and district cooling plants from a conversation with Claude. Claude collects your plant data, picks a real EPW weather file with you, and runs the plant for a full year on the eModely engine. You get annual and monthly energy, kW/TR, peak demand, the pump, tower and chiller split, warnings, and a download link for the hourly results.

The numbers come from the eModely engine running on eModely's servers, not from an AI estimate. This plugin contains only connection settings and instructions for Claude. It contains no engine code or data.

**You need** an eModely engine account with an active subscription (accounts are created by eModely; contact eModely to get one), and a paid Claude plan (Pro, Max, Team or Enterprise) to add plugins on claude.ai and Desktop.

## 1. Install

Pick the app you use. A plugin you add on claude.ai also appears in the Claude desktop app, on mobile and in Claude Code (as `emodely-engine@synced`), so you only need to install it once.

### claude.ai, Claude Desktop and mobile

1. Get the plugin zip (`emodely-engine-<version>.zip`) from eModely.
2. In claude.ai or the desktop app, open **Customize > Plugins**, then **Add > Upload plugin**, and select the zip.
3. Open the **eModely Engine** plugin, go to its **Connectors** tab, and click **Connect** next to `emodely-engine`.
4. A browser window opens on engine.emodely.com. Sign in with your eModely engine account, then click **Allow**.
5. In a chat, click **+ > Connectors** and check that **emodely-engine** is switched on.

On a Team or Enterprise plan, an Owner must first add the connector for the organization; members then connect with their own eModely account.

If you only want the connection without the plugin's instructions, add it as a custom connector instead: **Customize > Connectors > Add custom connector**, name `eModely Engine`, URL `https://engine.emodely.com/mcp`, leave **Advanced settings** empty, click **Add**, then **Connect** and sign in as in step 4. The engine's own built-in guidance still applies.

### Claude Code

eModely gives you read access to this GitHub repository. Claude Code clones it with the git credentials already on your computer and never asks for a password, so first make sure `git` can reach GitHub as you (for example `gh auth login`, then `gh auth setup-git`). Then, in Claude Code:

```text
/plugin marketplace add Ahlabeeb/emodely-claude-plugin
/plugin install emodely-engine@emodely
```

Choose **Install for you (user scope)**. Then run `/mcp`, select `plugin:emodely-engine:emodely-engine`, choose **Authenticate**, and sign in and click **Allow** in the browser window that opens.

If you already added the plugin on claude.ai and run Claude Code 2.1.273 or later signed in with the same claude.ai account, skip the install: it is synced into Claude Code as `emodely-engine@synced`. On older versions, install from the marketplace as above. You still run `/mcp` once to sign in.

**API key instead of browser sign-in (Claude Code only).** If eModely issued you a personal API key, set it as the environment variable `EMODELY_API_KEY` and add the server yourself. Keep the single quotes (bash, zsh or PowerShell), so the config stores the `${EMODELY_API_KEY}` reference and not the key itself:

```bash
claude mcp add --scope user --transport http emodely-engine-key https://engine.emodely.com/mcp --header 'Authorization: Bearer ${EMODELY_API_KEY}'
```

Then disable the plugin's own `emodely-engine` server in `/mcp`, so Claude does not see the tools twice. The plugin cannot carry the API key itself: a configured key header turns off browser sign-in for everyone else.

## 2. Weather files

Every run uses a real EPW weather file. The engine never generates weather.

- **The eModely library** covers Gulf and MENA cities. Name your project city and Claude finds the file.
- **Your own file**: ask Claude to upload a weather file. Claude gives you a link that is valid for 30 minutes. Open it, sign in with the same account, and upload the `.epw`. Your file is private to your account and is used before the library file for the same city. The file never passes through the chat.

Before the first run with a weather file, Claude tells you which file it will use (city, station, source and period). Replying without objecting accepts it; if you ask Claude to assume everything and the city match is clear, it runs straight away and names the file in the results. If several cities share the name, you choose. If there is no file for your city, Claude does not run; it offers the upload link and may suggest a nearby library city, which it uses only if you agree.

## 3. Typical prompts

- "Simulate a 2,000 TR water-cooled chiller plant in Dubai: four 500 TR centrifugal chillers, variable primary pumping, 6.7 °C supply."
- "Which weather files do you have for Riyadh?"
- "I want to upload my own weather file for Muscat."
- "Re-run the same plant with a 1 °C higher chilled-water supply temperature and compare kW/TR."
- "Give me the hourly results as an Excel file."
- "Explain the warnings in that run."

## 4. What to expect

- Before the first run, Claude asks a few short questions (for example new or existing plant, chillers, chilled-water temperatures, pumping, load), each with a recommended answer and lettered choices. Reply with your picks (for example "1b, 2 assume"); anything you skip takes the recommended answer. You can also ask Claude to assume everything from the city and plant size. You can change any input later in the chat and Claude re-runs.
- Claude's apps may ask permission before each engine tool call and show the raw tool input. That box is not where you check inputs; the chat is. Choosing **Always allow** for the eModely tools is convenient: it stops the per-call prompts (so runs, which count toward your fair-use limit, start without a click) but never locks your inputs, and Claude still asks its questions and names the weather file in the chat.
- Claude reports the engine version, the weather file used, every default it assumed and every warning.
- Hourly results never enter the chat. You get a download link that only your account can open; it expires after 24 hours. Ask Claude for a fresh CSV or Excel link at any time.
- Chiller curves, coefficients and engine internals are confidential. Claude will not try to reveal them.
- Fair-use limits apply (currently 60 simulations and 30 export links per hour).

## 5. Troubleshooting

| You see | What to do |
|---|---|
| The connector asks you to sign in again, or sign-in fails | Your session expired or the email or password is wrong. Reconnect and sign in again. |
| You signed in but see "Access denied" | Your account has no active engine subscription. Contact eModely. |
| An upload link says it has expired or is invalid | Upload links last 30 minutes. Ask Claude for a new one. |
| `emodely-engine-key` shows "Failed to connect" in `/mcp` | `EMODELY_API_KEY` is not set in the environment Claude Code started from, or the key was revoked. |
| Claude says it has no eModely tools | Connect the connector (step 1) and make sure it is switched on in the chat. |
| "Needs authentication" in Claude Code | Run `/mcp` and authenticate `emodely-engine` again. |
| "The engine is busy" or a limit message | Wait a few minutes and try again. |

## Terms of use

Use of the engine is subject to the eModely Engine Terms of Use at <https://engine.emodely.com/terms>. Results are engineering estimates: check the inputs and results, and you remain responsible for design and investment decisions. Reverse engineering the engine, or running systematic series of simulations to map its behaviour, is not allowed.

## Updates

Engine updates need no plugin release. The engine, its tools' descriptions and Claude's working rules (which questions to ask, the order of work, how to report) are served by engine.emodely.com and update with every engine deploy, for plugin and connector users alike. The plugin's skill is deliberately generic: it tells Claude to follow the engine's current rules and adds only guarantees that never change. The plugin only changes when tools are added or renamed, or another eModely engine is added. When that happens, eModely shares a new zip (claude.ai), or Claude Code users run `/plugin`, open **eModely Engine** on the **Installed** tab and choose **Update now**.

## For maintainers

- Contents are limited to config, skill text and docs. `scripts/check-no-leaks.sh` (also in CI) fails on any other file, on engine identifiers, on internal hosts and on anything that looks like a key or a coefficient table.
- `bash scripts/package-plugin.sh` builds `dist/emodely-engine-<version>.zip` from the committed plugin folder for **Upload plugin**.
- Raise `version` in `plugins/emodely-engine/.claude-plugin/plugin.json` on every plugin release; Claude Code users stay on the installed version until it changes.
- Validate with `claude plugin validate .` and `claude plugin validate ./plugins/emodely-engine --strict`.
