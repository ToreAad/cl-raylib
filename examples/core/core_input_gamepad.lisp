(require :cl-raylib)

(defpackage :raylib-user
  (:use :cl :raylib :3d-vectors))

(in-package :raylib-user)

(defun main ()
  (let ((xbox-alias-1 "xbox")
	(xbox-alias-2 "x-box")
	(ps-alias "playstation")
	(screen-width 800)
        (screen-height 450)
	(left-stick-deadzone-x 0.1)
	(left-stick-deadzone-y 0.1)
	(right-stick-deadzone-x 0.1)
	(right-stick-deadzone-y 0.1)
	(left-trigger-deadzone -0.9)
	(right-trigger-deadzone -0.9)
	(gamepad 0))
    (with-window (screen-width screen-height "raylib [core] example - gamepad input")
      (set-target-fps 60)	       ; Set our game to run at 60 FPS
      (set-config-flags :flag-msaa-4x-hint)
      (let ((tex-ps3-pad (load-texture (uiop:native-namestring
					(asdf:system-relative-pathname 'cl-raylib
								       "examples/core/resources/ps3.png"))))
	    (tex-xbox-pad (load-texture (uiop:native-namestring
					 (asdf:system-relative-pathname 'cl-raylib
									"examples/core/resources/xbox.png")))))
	(loop
	  until (window-should-close) ; detect window close button or ESC key
	  do (with-drawing
	       (clear-background :raywhite)
	       (when (and  (is-key-pressed :key-left) (> gamepad 0)) (decf gamepad))
	       (when (and  (is-key-pressed :key-right)) (incf gamepad))
	       (if (is-gamepad-available gamepad)
		   (progn 
		     (draw-text (format nil "GP~d: ~s" gamepad (get-gamepad-name gamepad)) 10 10 10 :black)
		     ;; Get axis values
		     (let ((left-stick-x (get-gamepad-axis-movement gamepad :gamepad-axis-left-x))
			   (left-stick-y (get-gamepad-axis-movement gamepad :gamepad-axis-left-y))
			   (right-stick-x (get-gamepad-axis-movement gamepad :gamepad-axis-right-x))
			   (right-stick-y (get-gamepad-axis-movement gamepad :gamepad-axis-right-y))
			   (left-trigger (get-gamepad-axis-movement gamepad :gamepad-axis-left-trigger))
			   (right-trigger (get-gamepad-axis-movement gamepad :gamepad-axis-right-trigger))
			   (left-gamepad-color :black)
			   (right-gamepad-color :black))
		       (when (and (> left-stick-x (- left-stick-deadzone-x)) (< left-stick-x left-stick-deadzone-x))
			 (setf left-stick-x 0.0))
		       (when (and (> left-stick-y (- left-stick-deadzone-y)) (< left-stick-y left-stick-deadzone-y))
			 (setf left-stick-y 0.0))
		       (when (and (> right-stick-x (- right-stick-deadzone-x)) (< right-stick-x right-stick-deadzone-x))
			 (setf right-stick-x 0.0))
		       (when (and (> right-stick-y (- right-stick-deadzone-y)) (< right-stick-y right-stick-deadzone-y))
			 (setf right-stick-y 0.0))
		       (when (< left-trigger left-trigger-deadzone) (setf left-trigger -1.0))
		       (when (< right-trigger right-trigger-deadzone) (setf right-trigger -1.0))

		       (cond
			 ((or (> (text-find-index (text-to-lower (get-gamepad-name gamepad)) xbox-alias-1) -1)
			      (> (text-find-index (text-to-lower (get-gamepad-name gamepad)) xbox-alias-2) -1))
			  (draw-texture tex-xbox-pad 0 0 :darkgray)

			  ;; Draw buttons: xbox home
			  (when (is-gamepad-button-down gamepad :gamepad-button-middle) (draw-circle 394 89 19.0 :red))
			  
			  ;;  Draw buttons: basic
			  (when (is-gamepad-button-down gamepad :gamepad-button-middle-right) (draw-circle 436 150 9.0 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-middle-left) (draw-circle 352 150 9.0 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-face-left) (draw-circle 501 151 15.0 :blue))
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-face-down) (draw-circle 536 187 15.0 :lime))
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-face-right) (draw-circle 572 151 15.0 :maroon))
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-face-up) (draw-circle 536 115 15.0 :gold))

			  ;; Draw buttons: d-pad
			  (draw-rectangle 317 202 19 71 :black)
			  (draw-rectangle 293 228 69 19 :black)
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-face-up) (draw-rectangle 317 202 19 26 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-face-down) (draw-rectangle 317 (+ 202 45) 19 26 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-face-left) (draw-rectangle 292 228 25 19 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-face-right) (draw-rectangle (+ 292 44) 228 26 19 :red))

			  ;; Draw buttons: left-right back
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-trigger-1) (draw-circle 259 61 20.0 :red))
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-trigger-1) (draw-circle 536 61 20.0 :red))

			  ;; Draw axis: left joystick
			  
			  (when (is-gamepad-button-down gamepad :gamepad-button-left-thumb)
			    (setf left-gamepad-color :red))
			  (draw-circle 259 152 39.0 :black)
			  (draw-circle 259 152 34.0 :lightgray)
			  (draw-circle (floor (+  259  (* left-stick-x 20)))
				       (floor (+ 152 (* left-stick-y 20))) 25.0 left-gamepad-color)
			  
			  ;; Draw axis: right joystick
			  (when (is-gamepad-button-down gamepad :gamepad-button-right-thumb)
			    (setf right-gamepad-color :red))
			  (draw-circle 461 237 38.0 :black)
			  (draw-circle 461 237 33.0 :lightgray)
			  (draw-circle (floor (+ 461 (* right-stick-x 20)))
				       (floor (+ 237 (* right-stick-y 20))) 25.0 right-gamepad-color)

			  ;; Draw axis: left-right triggers
			  (draw-rectangle 170 30 15 70 :gray)
			  (draw-rectangle 604 30 15 70 :gray)
			  (draw-rectangle 170 30 15 (floor (* (/ (+ 1 left-trigger) 2) 70)) :red)
			  (draw-rectangle 604 30 15 (floor (* (/ (+ 1 right-trigger) 2) 70)) :red))
			 ((> (text-find-index (text-to-lower (get-gamepad-name gamepad)) ps-alias) -1)
			  (draw-texture tex-ps3-pad 0 0 :darkgray)
			  ;; TODO
			  )
			 (t
			  (draw-rectangle-rounded (make-rectangle :x 175 :y 110 :width 460 :height 220) 0.3 16 :darkgray)
			  ;; TODO
			  ))
		       
		       (draw-text (format nil "DETECTED AXIS (~d):" (get-gamepad-axis-count gamepad)) 10 50 10 :maroon)
		       (dotimes (i (get-gamepad-axis-count 0))
			 (draw-text (format nil "AXIS ~d: ~,2f" i (get-gamepad-axis-movement gamepad i)) 20 (+ 70 (* 20 i)) 10 :darkgray))
		       (if (not (equal (get-gamepad-button-pressed) :gamepad-button-unknown))
			   (draw-text (format nil "DETECT BUTTON: ~a" (get-gamepad-button-pressed)) 10 430 10 :red)
			   (draw-text "DETECTED BUTTON: NONE" 10 430 10 :gray))))
		   (progn
		     (draw-text (format nil "GP~d: NOT DETECTED" gamepad) 10 10 10 :gray)
		     (draw-texture tex-xbox-pad 0 0 :lightgray)))))
	(unload-texture tex-ps3-pad)
	(unload-texture tex-xbox-pad)))))
(main)

