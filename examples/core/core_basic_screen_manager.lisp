(require :cl-raylib)

(defpackage :raylib-user
  (:use :cl :raylib))

(in-package :raylib-user)

(defun main ()
  (let ((screen-width 800)
        (screen-height 450)
	(frame-counter 0)
	(current-screen :LOGO))
    (with-window (screen-width screen-height "raylib [core] example - basic screen manager")
      (set-target-fps 60)	       ; Set our game to run at 60 FPS
      (loop
        until (window-should-close) ; detect window close button or ESC key
        do (case current-screen
	     (:LOGO
	      (incf frame-counter)
	      (when (> frame-counter 120)
		(setf current-screen :TITLE)))
	     (:TITLE
	      (when (or (is-key-pressed :key-enter)
			(is-gesture-detected :gesture-tap))
		(setf current-screen :GAMEPLAY)))
	     (:GAMEPLAY
	      (when (or (is-key-pressed :key-enter)
			(is-gesture-detected :gesture-tap))
		(setf current-screen :ENDING)))
	     (:ENDING
	      (when (or (is-key-pressed :key-enter)
			(is-gesture-detected :gesture-tap))
		(setf current-screen :TITLE))))
	   (with-drawing
	     (clear-background :raywhite)
	     (case current-screen
	       (:LOGO
		(draw-text "LOGO SCREEN" 20 20 40 :lightgray)
		(draw-text "WAIT for 2 seconds" 290 220 20 :gray))
	       (:TITLE
		(draw-rectangle 0 0 screen-width screen-height :green)
		(draw-text "TITLE SCREEN" 20 40 40 :darkgreen)
		(draw-text "PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN"
			   120 220 20 :darkgreen))
	       (:GAMEPLAY
		(draw-rectangle 0 0 screen-width screen-height :purple)
		(draw-text "GAMEPLAY SCREEN" 20 20 40 :maroon)
		(draw-text "PRESS ENTER or TAP to JUMP to ENDING SCREEN"
			   130 220 20 :maroon))
	       (:ENDING
		(draw-rectangle 0 0 screen-width screen-height :blue)
		(draw-text "ENDING SCREEN" 20 20 40 :darkblue)
		(draw-text "PRESS ENTER or TAP to RETURN to TITLE SCREEN"
			   120 220 20 :darkblue)))
             (draw-fps 20 20))))))

(main)

