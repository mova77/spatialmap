# SpatialMap (MindMap 3D) — 2007

> *"We share everything we made."* — VKSL project description, 2007

Interactive 3D mind maps for the Second Life virtual world, written in LSL
(Linden Scripting Language). Built 2007–2010 by **Vision Raymaker** (Marco Vanadia)
and **JonnyBee Cioc** (Davide Caroli) within **VKSL — Visual Knowledge in Second
Life**, an open research group born on the island of **Vulcano** under David Orban's
experimental governance.

Knowledge you could walk through: nodes, links, and a server orchestrating a
spatial map you built and navigated in-world — years before "graph view" was a
feature anyone shipped.

## Provenance

This is a faithful recovery (2026-07-24) of the project from the Google Code
Archive, after the original `code.google.com/p/spatialmap` was frozen with Google
Code's 2016 shutdown:

- Release source: `Spatial Map v1.0.18.zip` — [Google Code Archive downloads](https://code.google.com/archive/p/spatialmap/)
- Project metadata: [`archive/google-code-project.json`](archive/google-code-project.json)
- Wiki stub: [`archive/Manual.wiki`](archive/Manual.wiki)
- Historical discussion (license enforcement, 2010): [SL Wiki Talk:Wiki3DBuilder (archived)](https://web.archive.org/web/20260516182251/https://wiki.secondlife.com/wiki/Talk:Wiki3DBuilder)
- Cited in: Tish Shute, ["The Archeology and Future of Software Design: Meeting Grady Booch"](http://www.ugotrade.com/2008/01/28/the-archeology-and-future-of-software-design-meeting-grady-booch/), UgoTrade, 28 Jan 2008

## License

**Creative Commons Attribution-NonCommercial-ShareAlike 2.5 Italy**
(CC BY-NC-SA 2.5 IT), as declared in every source header since version 0 (2007).
The original license headers are preserved untouched:

```
// VKSL - Visual Knowledge in Second Life
// 2007(c) CC License by-nc-sa-2.5-it
//
// Authors:
//     JonnyBee Cioc    jonny@vulca.no
//     VisionRaymaker   vision.raymaker@vulca.no
```

Derive freely, share alike, **do not profit from it** — as its authors wrote, and
once had to remind someone publicly.

## Structure

| Folder | Scripts | Role |
|---|---|---|
| `Server/` | server.lsl, menu.lsl, proxy.lsl | Map orchestration, menus, external URL proxy |
| `Node/` | node.lsl, title.lsl | Map nodes (the ideas) |
| `Link/` | link.lsl, linkmenu.lsl, title.lsl | Edges between nodes |
| `Mover/` | mover.lsl | In-world object movement |

## Lineage

SpatialMap (2007, LSL, Second Life) → … → [meta-os](https://github.com/meta-agentic/meta-os)
(2026, agentic OS with a living knowledge graph). Same idea, nineteen years apart:
**knowledge is spatial, navigable, and meant to be shared.**
