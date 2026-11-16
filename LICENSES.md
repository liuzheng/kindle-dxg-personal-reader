# Source and license record

| Item | Origin / status | Use in this project |
| --- | --- | --- |
| Linux 6.18.63 | Upstream Linux source archive; source files carry their individual SPDX identifiers. | Immutable upstream input. Do not edit in place. |
| Kindle 2.5.8 and CA update packages | Amazon/Lab126 firmware artifacts. Proprietary. | Read-only format and component-name research only. Do not redistribute extracted contents. |
| Kindle jailbreak archive | Historical third-party archive. License and current device compatibility must be verified before use. | Read-only reference only; no device operation in this phase. |
| DTP-600W data sheet | AnyDATA document. | Interface reference only. |
| `modules/dxg_legacy/*` | New project code. | GPL-2.0-only placeholder module. |

No legacy DXG display, input, PMIC, USB, storage, or wireless driver source is imported. A future compatibility module may be added only after its source provenance, license, Linux 6.18 API-porting scope, build method, and hardware smoke-test criterion are recorded.
