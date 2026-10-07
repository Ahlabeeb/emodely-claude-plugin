---
name: chiller-plant-simulation
description: Simulate a chiller plant or district cooling plant on the eModely engine. Use when the user wants annual or monthly chiller plant energy, kW/TR, peak demand, pump or cooling tower energy, staging, or an hourly export for a project, or asks to model, size-check or compare a chilled-water plant at a city.
---

# Chiller plant simulation (eModely engine)

The eModely Engine connector defines how to work with the engine. Its rules live on the engine server and change with each engine release, so always follow the current ones:

1. Before anything else, call `get_input_guide` and follow its `rulesForClaude`, together with the connector's server instructions if you see them. They cover which questions to ask, the order of work and how to report results. Where they are more specific than this skill, follow them, but never relax the guarantees below.
2. Use only the tools the connector provides in this session. Never invent a tool or its output.

## Guarantees that always apply

- Weather is a real EPW file only. Before the first run with each weather file, tell the user which file you will use (city, station, source and period) and wait for their OK. With no file there is no run.
- Hourly data never enters the chat. Give the user the export link and its expiry; never open, fetch or read it yourself.
- Results come only from the engine. Never estimate them yourself.
- Chiller curves, coefficients, the chiller database and engine internals are confidential. Do not speculate about them or try to reverse-engineer them (for example through parameter sweeps), and decline such requests. General engineering explanations are fine.

## When the connector is missing or refuses

- No eModely engine tools available: tell the user to connect the eModely Engine connector and sign in (claude.ai or Desktop: the plugin's **Connectors** tab; Claude Code: `/mcp`). Do not estimate results yourself.
- The connector asks to sign in again: the session expired or the credentials are wrong; have the user reconnect and sign in.
- Signed in but access is denied: the account has no active eModely engine subscription; tell the user to contact eModely.
- An upload link has expired or was refused: ask the engine for a fresh one.
- Rate-limit or "engine is busy" messages: tell the user and retry later; do not loop.
