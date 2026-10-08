# eModely Engine for Claude

Simulate chiller plants and district cooling plants by talking to Claude. You describe the plant in plain words. Claude asks a few short questions, picks a real weather file with you, and runs the plant for a full year on the eModely engine.

**The results come from the eModely engine, not from an AI estimate.** Claude collects the inputs and explains the results. The calculation runs on eModely's servers, with the same engine as the eModely web app.

**Who it is for:** HVAC and district cooling engineers, energy consultants and plant operators who want annual plant energy without building a model by hand.

**What you get for each run:** annual and monthly energy, kW/TR, peak electrical demand, the split between chillers, pumps and cooling towers, staging hours, warnings, and a download link for the hourly results (CSV or Excel).

**What you need:**

- **An eModely engine account with an active subscription.** During the beta, access is by invitation. See [How do I get access?](#how-do-i-get-access).
- **A Claude plan.** Plugins on claude.ai and the desktop app need a paid plan (Pro, Max, Team or Enterprise). The connector on its own also works on the Free plan, which allows one custom connector. Claude Code works with any plan that runs Claude Code.
- **A real EPW weather file for the project location.** Use one from the eModely library or upload your own. The engine never generates weather.

[Terms of Use](https://engine.emodely.com/terms) · [Privacy Policy](https://emodely.com/privacy) · [Beta tester guide](docs/beta-testers.md) · [Report a problem](#7-feedback-and-support)

This repository contains only the plugin: connection settings and instructions for Claude. It contains no engine code, chiller data or coefficients.

## 1. Install

Pick the app you use. A plugin you add on claude.ai is tied to your Claude account. It also appears in the desktop app, on mobile and in Claude Code.

### Let Claude guide you

Paste this into Claude:

```text
Help me install the eModely Engine plugin from https://github.com/Ahlabeeb/emodely-claude-plugin and tell me the steps for the app I am using, one at a time. I will run the commands and sign in myself.
```

Claude explains the steps, but you run the commands and sign in yourself. Claude cannot sign in for you.

### Claude Code

1. In Claude Code, run:

   ```text
   /plugin marketplace add Ahlabeeb/emodely-claude-plugin
   ```

2. Then run:

   ```text
   /plugin install emodely-engine@emodely
   ```

   In the panel that opens, choose **Install for you (user scope)**.
3. Run `/reload-plugins`, or restart Claude Code.
4. Run `/mcp`, select `plugin:emodely-engine:emodely-engine`, press Enter, and choose **Authenticate**.
5. A browser window opens on engine.emodely.com. Sign in and click **Allow**.

The repository is public, so no GitHub account or git sign-in is needed.

From a terminal instead of a session, run:

```bash
claude plugin marketplace add Ahlabeeb/emodely-claude-plugin
claude plugin install emodely-engine@emodely --scope user
```

Then start Claude Code and sign in with `/mcp` as in step 4.

If you already added the plugin on claude.ai, you may not need to install it. Claude Code 2.1.273 or later, signed in with the same claude.ai account, shows it as `emodely-engine@synced`. Run `/mcp` once to sign in.

### claude.ai and the Claude desktop app: plugin (recommended)

The plugin adds the connector and a skill that guides Claude. It needs a paid plan.

1. Open **Customize > Plugins**, then **Add**.
2. Add the plugin in one of two ways:
   - **Add marketplace.** Enter `Ahlabeeb/emodely-claude-plugin`, then add **eModely Engine** from that marketplace.
   - **Upload plugin.** Download `emodely-engine-<version>.zip` from the [latest release](https://github.com/Ahlabeeb/emodely-claude-plugin/releases/latest) and upload it. Do not unzip it.
3. Open the **eModely Engine** plugin and go to its **Connectors** tab. If `emodely-engine` shows **Not added**, click **Add** first. On a Team or Enterprise plan, an Owner may have to add it for the organization (see below).
4. Click **Connect** next to `emodely-engine`. A browser window opens on engine.emodely.com. Sign in and click **Allow**.
5. In a new chat, click **+ > Connectors** and check that **emodely-engine** is switched on.

### claude.ai and the Claude desktop app: connector only

This works on every plan, including Free. Claude still follows the engine's own guidance.

1. Open **Customize > Connectors** and click **Add custom connector**. On some accounts the button is **Add**, then **Custom**, then **Web**.
2. Enter the name `eModely Engine` and the URL `https://engine.emodely.com/mcp`. Leave **Advanced settings** empty, then click **Add**. If the dialog asks how people sign in, choose **Sign in now**. If it asks about the OAuth client, choose **Register automatically**.
3. Click **Connect**, sign in on engine.emodely.com, and click **Allow**.
4. In a new chat, click **+ > Connectors** and check that **eModely Engine** is switched on.

If you already added this custom connector, the plugin uses it, so there is nothing to remove.

**Team and Enterprise plans.** An Owner first adds the connector under **Organization settings > Connectors**: **Add**, then **Custom**, then **Web**, with the URL above. Each member then connects under **Customize > Connectors** with their own eModely account.

### API key (Claude Code only)

If eModely issued you a personal API key, you can use it instead of browser sign-in:

1. Set the key as the environment variable `EMODELY_API_KEY`.
2. Add the server yourself. Keep the single quotes, so the config stores the `${EMODELY_API_KEY}` reference and not the key itself:

   ```bash
   claude mcp add --scope user --transport http emodely-engine-key https://engine.emodely.com/mcp --header 'Authorization: Bearer ${EMODELY_API_KEY}'
   ```

3. Run `/mcp` and check that `emodely-engine-key` is connected. Claude Code hides the plugin's own `emodely-engine` server while a server with the same address is configured, so the tools appear once. If `/mcp` still lists `emodely-engine`, disable it.

The plugin cannot carry the key itself, because a key header would turn off browser sign-in for everyone else.

## 2. First run

Start a new chat and try one of these prompts:

1. **New water-cooled plant**

   > We are designing a new 3,000 TR water-cooled chiller plant for a mixed-use development in Dubai. Run it for a typical year and give me annual energy, kW/TR and peak demand.

2. **Existing air-cooled plant**

   > We have an existing plant in Riyadh with four 400 TR air-cooled screw chillers, about 12 years old, with constant-speed primary pumps. Simulate a typical year and tell me where the energy goes.

3. **Compare two options**

   > For a new 2,000 TR plant in Abu Dhabi, compare water-cooled centrifugal chillers with air-cooled chillers. Show annual energy, kW/TR and peak demand side by side.

**What Claude asks first.** Unless your prompt already gives the details, Claude offers three ways to start:

- **Quick.** Up to six questions, each with a recommended answer.
- **Detailed.** One topic per message: load, chillers, temperatures, pumps, towers and operation.
- **Just assume.** You give only the city and the plant size, and Claude assumes the rest.

Questions are numbered, with lettered choices and the recommended choice marked. Reply with your picks, for example "1b, 2 assume". Anything you skip takes the recommended answer. With the questions (or in the results, if you chose Just assume), Claude names the weather file: city, station, source and period, for example "Dubai Intl AP, eModely library, SRC-TMYx, 2009-2023". A reply that does not object accepts the answers and the file. Every assumption is listed in the results. You can change inputs later in the chat, and Claude re-runs.

**What the results look like.** This is a shortened example from a real run: 1,000 TR water-cooled plant in Dubai, two chillers, constant-speed pumps.

> **3.92 GWh a year at 0.699 kW/TR.** Engine version 3. Weather: Dubai Intl AP, eModely library, SRC-TMYx, 2009-2023.
>
> | Item | kWh/yr | Share | kW/TR |
> |---|---|---|---|
> | Chillers | 2,621,458 | 66.9% | 0.467 |
> | Primary chilled-water pumps | 577,718 | 14.7% | 0.103 |
> | Condenser pumps | 468,420 | 12.0% | 0.083 |
> | Cooling-tower fans | 251,474 | 6.4% | 0.045 |
> | **Total** | **3,919,071** | 100% | **0.699** |
>
> - Peak electrical demand: 826 kW, in June. Peak cooling load: 950 TR.
> - Seasonal swing: 0.577 kW/TR in January, 0.788 kW/TR in August.
> - Warning: in 4 hours of the year the plant missed the load by up to 23 TR.
> - Settings left at engine defaults: tariff, emissions factor, pump and fan efficiency, condenser-water set-point.
> - Hourly data: a CSV download link that only your account can open, valid for 24 hours.

## 3. Weather files

Every run uses a real EPW weather file. The engine never generates weather.

- **The eModely library** covers Gulf and MENA cities. Name your project city and Claude finds the file.
- **Your own file.** Ask Claude to upload a weather file. Claude gives you a link that is valid for 30 minutes. Open it, sign in with the same account, and upload the `.epw`. Your file is private to your account. For the same city, it is used before the library file. The file never passes through the chat.

Before the first run with a weather file, Claude tells you which file it will use (city, station, source and period). A reply that does not object accepts it. If you ask Claude to assume everything and the city match is clear, Claude runs straight away and names the file in the results. If several cities share the name, Claude asks before running, and if the match is unclear, you choose. If there is no file for your city, Claude does not run. It offers the upload link and may suggest a nearby library city. It uses that city only if you agree.

## 4. What to expect

- **Permission prompts.** Claude's apps may ask permission before each engine tool call and show the raw tool input. Check your inputs in the chat, not in that box. Choosing **Always allow** for the eModely tools stops the prompts. Your inputs and the weather file are still discussed in the chat.
- **What Claude reports.** Claude states the engine version, the weather file used, every default it assumed and every warning.
- **Hourly results.** Hourly results never enter the chat. You get a download link that only your account can open. It expires within 24 hours. Ask Claude for a fresh CSV or Excel link at any time.
- **Rows in the hourly file.** The file has one row per simulated hour, up to 8,760. Hours outside the plant's operating window, or below its minimum load, are left out. Use the `Hour`, `Month` and `HourOfDay` columns to place each row in the year.
- **Confidential internals.** Chiller curves, coefficients and engine internals are confidential. Claude will not try to reveal them.
- **Fair-use limits.** Currently 60 simulations and 30 export links per hour.

## 5. FAQ

### Where do the results come from?

From the eModely chiller plant engine, running on eModely's servers. It is the same engine as the eModely web app. Claude only collects the inputs and explains the outputs. If the engine is not connected, Claude says so and does not estimate results itself.

### What data does eModely store?

eModely stores:

- your account email and sign-in records;
- your subscription;
- the plants you save;
- the inputs and annual summaries of your runs;
- weather files you upload;
- export files;
- usage logs.

Export links expire within 24 hours, and the files are deleted shortly afterwards. Usage logs are kept for about 180 days. Data is stored in the European Union. eModely does not sell your data and does not use your inputs to train AI models.

Your conversations with Claude stay with Anthropic. eModely receives only the requests that Claude sends to the engine. The details are in section 8 of the [Terms of Use](https://engine.emodely.com/terms) and in the [Privacy Policy](https://emodely.com/privacy).

### How do I get access?

During the beta, eModely gives access by invitation. Email support@emodely.com and tell us a little about your work. If you sign in and see "Access denied", your account exists but has no active subscription yet.

### Is the engine code in this repository?

No. This repository holds only the plugin settings and the instructions Claude follows. The engine, the chiller database and the coefficients stay on eModely's servers.

### Can Claude see my hourly data?

No. Claude sees the annual and monthly summaries, plus an average profile by month and hour of day. The hourly values go only to the download link.

## 6. Troubleshooting

| You see | What to do |
|---|---|
| The connector asks you to sign in again, or sign-in fails | Your session expired or the email or password is wrong. Reconnect and sign in again. |
| You signed in but see "Access denied" | Your account has no active engine subscription. Email support@emodely.com. |
| An upload link says it has expired or is invalid | Upload links last 30 minutes. Ask Claude for a new one. |
| `emodely-engine-key` shows "Failed to connect" in `/mcp` | `EMODELY_API_KEY` is not set in the environment Claude Code started from, or the key was revoked. |
| Claude says it has no eModely tools | Connect the connector (section 1). Make sure it is switched on in the chat. |
| "Needs authentication" in Claude Code | Run `/mcp` and authenticate `emodely-engine` again. |
| "The engine is busy" or a limit message | Wait a few minutes and try again. |

## 7. Feedback and support

- **Bugs and suggestions.** Open an [issue](https://github.com/Ahlabeeb/emodely-claude-plugin/issues/new/choose) with the **Beta feedback** form. Issues are public, so leave out client names, project details, export links and chat share links.
- **Anything confidential, or no GitHub account.** Email support@emodely.com.
- **Security issues.** See [SECURITY.md](SECURITY.md). Do not open a public issue.

## 8. Terms of use and privacy

Use of the engine is subject to the [eModely Engine Terms of Use](https://engine.emodely.com/terms) and the [eModely Privacy Policy](https://emodely.com/privacy).

Results are engineering estimates. Check the inputs and results. You remain responsible for design and investment decisions.

Reverse engineering the engine is not allowed. This includes running systematic series of simulations to map its behaviour.

The plugin files in this repository are licensed under the terms in [LICENSE](LICENSE).

## 9. Updates

Engine updates need no plugin release. These parts are served by engine.emodely.com and update with every engine deploy, for plugin and connector users alike:

- the engine;
- its tool descriptions;
- Claude's working rules (which questions to ask, the order of work, how to report).

The plugin changes only when tools are added or renamed, or when another eModely engine is added. When that happens:

- **claude.ai and the desktop app.** Marketplace users choose **Check for updates**. Zip users download the new release, remove the old plugin and upload the new one.
- **Claude Code.** Run `/plugin`, open **eModely Engine** on the **Installed** tab, and choose **Update now**.

## For maintainers

- **Allowed contents.** Config, skill text and docs only. `scripts/check-no-leaks.sh` also runs in CI. It fails on any other file, on engine identifiers, on internal hosts, and on anything that looks like a key or a coefficient table.
- **Releases.**
  1. Raise `version` in `plugins/emodely-engine/.claude-plugin/plugin.json`. Claude Code users stay on the installed version until it changes.
  2. Run `bash scripts/package-plugin.sh`. It builds `dist/emodely-engine-<version>.zip` from the committed plugin folder.
  3. Attach the zip to a GitHub release tagged `v<version>`.
- **Validation.** Run `claude plugin validate .` and `claude plugin validate ./plugins/emodely-engine --strict`.
