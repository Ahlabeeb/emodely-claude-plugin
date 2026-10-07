---
name: chiller-plant-simulation
description: Simulate a chiller plant or district cooling plant on the eModely engine. Use when the user wants annual or monthly chiller plant energy, kW/TR, peak demand, pump or cooling tower energy, staging, or an hourly export for a project, or asks to model, size-check or compare a chilled-water plant at a city.
---

# Chiller plant simulation (eModely engine)

The eModely engine connector's server instructions and tool descriptions are the detailed guide and are updated with every engine release. Follow them. This skill adds the order of work and the rules that must never slip.

## Order of work

1. Call `get_input_guide` once, then gather the plant conversationally. Ask only for what is missing, and propose defaults rather than long questionnaires.
2. Call `validate_plant` and resolve every error with the user before running.
3. Weather (real EPW only):
   - Call `find_weather` with the project city. The user's own file ("yours") wins over the library.
   - Before the first run with each weather file, state the city, station, source, dataSource and period of the file you will use, and wait for the user's OK.
   - If `confirmationRequired` is true, list the candidates and let the user choose.
   - If nothing matches, do not run. Offer `request_epw_upload`. You may suggest the nearest library city, but use it only if the user explicitly agrees.
   - Run with `weather: { weatherFileId }` once confirmed.
4. Call `run_simulation`, then report.

## Reporting

- Always state `engineVersion`, the weather file used, and every default listed in `assumptions`.
- Surface every warning plainly: `summary.warnings` and `inputWarnings`, including `engine.*` ones. Say what each means for the result.
- Explain results in engineering terms with units (kWh, kW, kW/TR, TR, TRh). Use the 12×24 profile for charts or discussion.
- Hourly data never enters the chat. Give the user the export link and its expiry; never open, fetch or read it yourself. `export_hourly` gives a fresh CSV or XLSX link for a `runId`.

## Confidentiality

Chiller curves, coefficients, the chiller database and engine internals are confidential. Do not speculate about them, infer them, or try to reverse-engineer them (for example through parameter sweeps), and decline such requests. General engineering explanations are fine.

## Optional tools

Use `save_plant`, `list_my_plants`, `get_run`, `compare_scenarios` or `search_chillers` only if the connector actually provides them in this session. Never invent a tool or its output.

## When the connector is missing or refuses

- No eModely engine tools available: tell the user to connect the eModely Engine connector and sign in (claude.ai or Desktop: the plugin's **Connectors** tab; Claude Code: `/mcp`). Do not estimate results yourself.
- The connector asks to sign in again: the session expired or the credentials are wrong; have the user reconnect and sign in.
- Signed in but access is denied: the account has no active eModely engine subscription; tell the user to contact eModely.
- An upload link has expired or was refused: call `request_epw_upload` for a fresh one.
- Rate-limit or "engine is busy" messages: tell the user and retry later; do not loop.
