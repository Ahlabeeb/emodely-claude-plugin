# eModely Engine beta: tester guide

Thank you for testing the eModely Engine in Claude. This guide adds the beta details to the [README](../README.md) and takes about 10 minutes.

## 1. Before you start

- **Beta access.** eModely switches on your access for a fixed period and tells you the end date.
- **Sign-in.** Use the sign-in you agreed with eModely: either Google with the email address you gave us, or the email and password eModely created for you.
- **A Claude plan.** See "What you need" in the README.

## 2. Install and sign in

Follow [section 1 of the README](../README.md#1-install) for your app. In claude.ai and the desktop app, the plugin is the recommended option.

When the browser window opens on engine.emodely.com, sign in and click **Allow**.

**If you see "Access denied" after signing in,** your access is not switched on yet, or it has ended. Reply to your invitation email. Try again after eModely confirms.

## 3. What to try

1. Run the three prompts in [section 2 of the README](../README.md#2-first-run): a new water-cooled plant, an existing air-cooled plant, and a comparison of two options.
2. Run a plant from one of your own projects. Leave out client names.
3. Ask for the hourly results as Excel, and open the download link.
4. Change one input, re-run, and ask Claude to compare the two runs.
5. Try a city that is not in the library, and upload your own EPW file through the link Claude gives you.

## 4. What to report

We want to hear about anything that is wrong, confusing or slow. Examples:

- results that look wrong to an engineer;
- a confusing question from Claude, or too many questions;
- an input you needed that Claude could not take;
- Claude estimating numbers itself instead of running the engine;
- problems with install, sign-in, upload or download.

**For each report, include:**

- the app you used (Claude Code, claude.ai, desktop or mobile);
- the date and time, with your time zone;
- your prompt;
- what happened and what you expected;
- the engine version and weather file that Claude reported;
- any error message, word for word, and a screenshot if you can.

## 5. How to report

- **Public issue.** Open an [issue](https://github.com/Ahlabeeb/emodely-claude-plugin/issues/new/choose) with the **Beta feedback** form. This is best for bugs and suggestions. Issues are public, so leave out client names, project locations, drawings, export links and chat share links.
- **Private email.** Write to support@emodely.com for anything confidential, or if you have no GitHub account.

## 6. Terms and limits

- Use of the engine is subject to the [eModely Engine Terms of Use](https://engine.emodely.com/terms) and the [eModely Privacy Policy](https://emodely.com/privacy).
- Results are engineering estimates. Check the inputs and results. You remain responsible for design and investment decisions.
- Do not try to reverse-engineer the engine. This includes running systematic series of simulations to map its behaviour.
- Fair-use limits apply: currently 60 simulations and 30 export links per hour.
