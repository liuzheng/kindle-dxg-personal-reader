# Driver boundaries

| Area | Local status | Physical evidence required before implementation |
| --- | --- | --- |
| E-Ink ED097OC1(LF) | No driver imported. The confirmed 34-pin panel identity is insufficient to choose scan, waveform, or power sequencing. | Display-controller and PMIC identity, vendor/usable source, waveform ownership, and boot logs. |
| Input | No driver imported. | Controller/bus identity and input-event capture. |
| NAND/MTD | Generic MTD options only. | `/proc/mtd`, boot arguments, partition dump, and recovery method. |
| USB gadget | Generic config fragment only. | USB role wiring and observed stock behavior. |
| Battery/charger/suspend | No driver imported. | PMIC identity, regulator map, charging state, and suspend logs. |
| Wi-Fi/Bluetooth | Deferred to Phase 2. | Post-Phase-1 USB, power, control, antenna, and mechanical measurements. |

Every non-upstream component must remain an independently buildable external module or narrowly scoped patch series until it is acceptable upstream.
