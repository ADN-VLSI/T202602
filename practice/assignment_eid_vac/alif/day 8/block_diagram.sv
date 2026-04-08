        +----------------------+
        |   Pedestrian Button  |
        +----------+-----------+
                   |
                   v
        +----------------------+
        |   Control FSM        |
        | (Traffic Logic)      |
        +----+----+----+-------+
             |    |    |
             v    v    v
           RED  YELLOW GREEN


/*explanation:
This project implements a Traffic Light Controller using FSM (Finite State Machine). The system cycles through three states: RED, GREEN, and YELLOW based on a timer.
A pedestrian request input is included to ensure safe crossing.

The controller uses synchronous logic with a clock signal. 
A timer is used to control how long each light remains active. 
The FSM transitions between states automatically after a fixed duration.*/