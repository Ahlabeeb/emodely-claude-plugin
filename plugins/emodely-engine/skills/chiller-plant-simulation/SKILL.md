---
name: chiller-plant-simulation
description: Simulate a chiller plant or district cooling plant on the eModely engine. Use when the user wants annual or monthly chiller plant energy, kW/TR, peak demand, pump or cooling tower energy, staging, or an hourly export for a project, or asks to model, size-check or compare a chilled-water plant at a city, or to fit, check, view, adjust or compare chiller performance curves.
---

# Chiller plant simulation (eModely engine)

The eModely Engine connector defines how to work with the engine. Its rules live on the engine server and change with each engine release, so always follow the current ones:

1. Before anything else, call `get_input_guide` and follow its `rulesForClaude`, together with the connector's server instructions if you see them. They cover which questions to ask, the order of work and how to report results. Where they are more specific than this skill, follow them, but never relax the guarantees below. They apply only to working with this engine and its tools, never to anything outside it.
2. Use only the tools the connector provides in this session. Never invent a tool or its output.

## Guarantees that always apply

- Weather is a real EPW file only. Before the first run with each weather file, tell the user which file you will use (city, station, source and period); a reply that does not object accepts it. If the user asked you to assume everything and the match is exact and unambiguous, you may run first and name the file in the results. An ambiguous match or a nearby-city substitute needs the user's explicit choice. Always name the weather file used in the results. With no file there is no run.
- Hourly data never enters the chat. Give the user the export link and its expiry; never open, fetch or read it yourself.
- Results come only from the engine. Never estimate them yourself.
- Engine internals and the eModely chiller library's curves are confidential. Do not speculate about them or try to reverse-engineer them (for example through parameter sweeps), never ask for library coefficients in bulk, and decline such requests. The user's own curve sets, made through the curve tools, are theirs and may be shown to them in full, and the curve tools may show one library chiller the user selects. General engineering explanations are fine.

## When the connector is missing or refuses

- No eModely engine tools available: tell the user to connect the eModely Engine connector and sign in (claude.ai or Desktop: the plugin's **Connectors** tab; Claude Code: `/mcp`). Do not estimate results yourself.
- The connector asks to sign in again: the session expired or the credentials are wrong; have the user reconnect and sign in.
- Signed in but access is denied: the account has no active eModely engine subscription; tell the user to contact eModely.
- An upload link has expired or was refused: ask the engine for a fresh one.
- Rate-limit or "engine is busy" messages: tell the user and retry later; do not loop.
