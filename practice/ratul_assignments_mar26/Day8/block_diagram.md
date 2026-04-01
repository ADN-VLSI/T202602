# Traffic Controller with Pedestrian Request - Block Diagram

```
+-------------------+     +-------------------+
|  Pedestrian       |     |  Traffic Light    |
|  Request Button   |---->|  Controller FSM   |---->|  Traffic Lights  |
|                   |     |                   |     |  (R, Y, G)       |
+-------------------+     +-------------------+     +-------------------+
                              |     |
                              |     |
                              v     v
                       +-------------------+
                       |  Timer/Counter    |
                       +-------------------+
                              |
                              v
                       +-------------------+
                       |  Pedestrian       |
                       |  Lights (R, G)    |
                       +-------------------+
```