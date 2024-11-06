# Rung 0: Check Start Conditions
IF classicladder.run_permission THEN
   RUN MainSequence  # Jump to Main Logic Sequence if all conditions are met
ENDIF

# Main Logic Sequence (Rungs 1 and 2 from previous logic)

# Rung 1: X-Axis Move to Max and Infeed at x_max
IF (x_position <= HAL_PIN_X_MIN) AND (HAL_PIN_INFEED_AT_X_LIMIT != 2) THEN
   CALL XMove_To_Max               # Move X to max
   WAIT UNTIL (x_position >= HAL_PIN_X_MAX)  # Wait until X reaches max

   # Execute Infeed at x_max if enabled
   IF HAL_PIN_ENABLE_INFEED == TRUE THEN
      IF HAL_PIN_INFEED_REPEAT_TYPE == 0 THEN
         CALL YMove_RepeatType0
      ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 1 THEN
         CALL YMove_RepeatType1
      ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 2 THEN
         CALL YMove_RepeatType2
      ENDIF
   ENDIF
ENDIF

# Rung 2: X-Axis Move to Min and Infeed at x_min
IF (x_position >= HAL_PIN_X_MAX) AND (HAL_PIN_INFEED_AT_X_LIMIT != 3) THEN
   CALL XMove_To_Min               # Move X to min
   WAIT UNTIL (x_position <= HAL_PIN_X_MIN)  # Wait until X reaches min

   # Execute Infeed at x_min if enabled
   IF HAL_PIN_ENABLE_INFEED == TRUE THEN
      IF HAL_PIN_INFEED_REPEAT_TYPE == 0 THEN
         CALL YMove_RepeatType0
      ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 1 THEN
         CALL YMove_RepeatType1
      ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 2 THEN
         CALL YMove_RepeatType2
      ENDIF
   ENDIF
ENDIF

# Rung 3: Z-Axis Downfeed Triggered by Y Limit Condition
IF HAL_PIN_ENABLE_DOWNFEED == TRUE THEN
   IF HAL_PIN_INFEED_REPEAT_TYPE == 0 THEN
      IF (y_position <= HAL_PIN_Y_MIN) OR (y_position >= HAL_PIN_Y_MAX) THEN
         CALL ZDownfeed
      ENDIF
   ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 1 THEN
      IF y_position >= HAL_PIN_Y_MAX THEN
         CALL ZDownfeed
      ENDIF
   ELSE IF HAL_PIN_INFEED_REPEAT_TYPE == 2 THEN
      IF y_position <= HAL_PIN_Y_MIN THEN
         CALL ZDownfeed
      ENDIF
   ENDIF
ENDIF
