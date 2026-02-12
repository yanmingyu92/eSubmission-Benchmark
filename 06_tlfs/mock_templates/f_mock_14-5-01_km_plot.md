# MOCK SHELL: Figure 14-5.01

## Kaplan-Meier Plot for Time to First Dermatologic Event

---

**Protocol:** CDISCPILOT01
**Population:** Safety

---

## Figure Description

```
+------------------------------------------------------------------+
|   KM Plot for Time to First Dermatologic Event: Safety Population|
+------------------------------------------------------------------+
|                                                                  |
|  1.0 +-------------------------------------------------------+   |
|      |                                                       |   |
|      |   [Curves for each treatment group]                   |   |
|  0.9 +                                                       +   |
|      |   Placebo          -------                            |   |
|      |   Xanomeline Low   - - - -                            |   |
|  0.8 +   Xanomeline High  .......                            +   |
|      |                                                       |   |
|  0.7 +                                                       +   |
|      |                                                       |   |
|  0.6 +                                                       +   |
| P    |   - - - - - - - - - - - - - - - - - - - - - - - - -   |   |
| r 0.5+   ^             (horizontal reference line at 0.5)    +   |
| o    |                                                       |   |
| b 0.4+                                                       +   |
| a    |                                                       |   |
| b 0.3+                                                       +   |
| i    |                                                       |   |
| l 0.2+                                                       +   |
| i    |                                                       |   |
| t 0.1+                                                       +   |
| y    |                                                       |   |
|  0.0 +-------------------------------------------------------+   |
|      0        50       100      150      200      250      300   |
|                     Time to First Dermatologic Event (Days)      |
|                                                                  |
+------------------------------------------------------------------+
|  Number at Risk                                                  |
|  Placebo              86    70    55    40    25    10    0      |
|  Xanomeline Low       84    60    40    25    15     5    0      |
|  Xanomeline High      84    50    30    15    10     2    0      |
+------------------------------------------------------------------+
```

---

## Figure Elements

| Element | Description |
|---------|-------------|
| X-axis | Time to First Dermatologic Event (Days) |
| Y-axis | Probability of Event |
| Curves | Kaplan-Meier survival curves by treatment group |
| Censoring marks | + symbols for censored observations |
| Confidence intervals | Shaded bands for 95% CI |
| Reference line | Horizontal dashed line at y=0.5 |
| Risk table | Number at risk by treatment group below plot |

---

## Legend

| Line Style | Treatment Group |
|------------|-----------------|
| Solid line | Placebo |
| Dashed line | Xanomeline Low Dose |
| Dotted line | Xanomeline High Dose |

---

## Annotations

- Median time to event (if estimable) with 95% CI
- Log-rank test p-value
- Number of events / Number of subjects by treatment

---

## Statistical Summary

| Treatment | N | Events | Median (95% CI) |
|-----------|---|--------|-----------------|
| Placebo | nn | nn | xxx.xx (xxx.xx, xxx.xx) |
| Xanomeline Low Dose | nn | nn | xxx.xx (xxx.xx, xxx.xx) |
| Xanomeline High Dose | nn | nn | xxx.xx (xxx.xx, xxx.xx) |

**Log-rank test p-value:** x.xxx

---

**Program:** tlf-kmplot.R
**Source:** ADTTE, ADSL
**Parameter:** TTDE (Time to First Dermatologic Event)

---

*Mock Shell Template - For specification purposes only*
