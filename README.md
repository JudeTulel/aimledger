# Aim Ledger

Aim Ledger is a play-to-earn scoreboard for a browser aim trainer, built as a Gno.land realm. It borrows the progression loop of games like Kirka — score, quests, streaks, leaderboard, rewards — and settles the whole loop on chain.

## What it does

- **Play** a 20-second aim trainer (in `web/index.html`, also served on GitHub Pages).
- **Submit** your score to the realm. Runs are rate-limited to one per 10 seconds and credits are capped daily, so the reward curve stays bounded.
- **Build a streak** by playing on consecutive UTC days.
- **Climb the leaderboard**, which ranks players by best score with address as the tie-breaker.
- **Earn** credits and redeem them for testnet GNOT from a funded prize pool: 100 credits = 0.001 GNOT, up to 1000 credits per claim.

Every significant action emits an on-chain event (`Run`, `Fund`, `Claim`).

## Deployment

- Realm: `gno.land/r/g16aehkv63k62ege7z7c7g5zc58mljklvtdkxd3u/aimledger`
- Chain: onyx-1 testnet
- Rendered page: https://gno.land/r/g16aehkv63k62ege7z7c7g5zc58mljklvtdkxd3u/aimledger
- Companion game: https://judetulel.github.io/aimledger/

The realm is deployed from the agent key generated for this build. Its address is in the package path above; no private key material is stored in this repository.

## Repository layout

```
realm/           Gno realm source, gnomod.toml and unit tests
web/             Standalone aim trainer (plain HTML/JS, no dependencies)
```

## Public API

| Function | Purpose |
|---|---|
| `Join(cur realm)` | Register the caller. Free and idempotent. |
| `SubmitScore(cur realm, score int)` | Record a run, award credits, update streak and best score. |
| `Fund(cur realm)` | Payable. Add ugnot to the prize pool. |
| `Claim(cur realm, credits int64)` | Redeem credits for ugnot from the pool. |
| `Top() []*Player` | Top ten players by best score. |
| `Credits(a address) int64` | Credit balance for an address. |
| `Pool() int64` | Current pool balance in ugnot. |

All state-changing entrypoints are crossing functions that require an EOA caller via `cur.Previous().IsUserCall()`. Helpers that receive a realm token check `cur.IsCurrent()` before using it as authority.

## Trust model

Scores are self-reported by the player. The VM has no access to browser input, so the realm cannot verify aim accuracy; it enforces what it can — score bounds, a cooldown, a daily credit cap, and pool solvency. This is an explicit, documented trade-off rather than a hidden weakness. A production version would add signed attestations from a game server.

## Local development

A chain-matched `gno` toolchain (v1.8.0-rc.1) was used to lint and test the realm:

```sh
cd realm
gno lint .
gno test .
```

## Demo

See `docs/demo.md` for a walkthrough of the play-to-earn loop.
