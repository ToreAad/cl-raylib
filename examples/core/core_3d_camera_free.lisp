(require :cl-raylib)

(defpackage :raylib-user
  (:use :cl :raylib :3d-vectors))

(in-package :raylib-user)

(defun main ()
  (let* ((screen-width 800)
	 (screen-height 450)
	 (camera-pos (vec 10.0 10.0 10.0))
	 (camera-target (vec 0.0 0.0 0.0))
	 (camera-up (vec 0.0 1.0 0.0))
	 (camera (make-camera3d :position camera-pos ; Camera position
				:target camera-target ; Camera looking at point
				:up camera-up	      ; Camera up vector (rotation towards target)
				:fovy 45.0	      ; Camera field-of-view Y
				:projection :camera-perspective)) ; Camera projection type
	 (cube-position (vec 0.0 0.0 0.0)))
    (with-window (screen-width screen-height "raylib [core] example - 3d camera free")
      (disable-cursor)		       ; Limit the cursor to relative movement inside the window.
      (set-target-fps 60)	       ; Set our game to run at 60 FPS
      (loop
        until (window-should-close) ; detect window close button or ESC key
        do
	   (update-camera camera :camera-free)
	   (when (is-key-pressed :key-z)
	     (setf (camera3d-target camera) (vec 0.0 0.0 0.0)))
	   (with-drawing
             (clear-background :raywhite)
	     (with-mode-3d (camera)
	       (draw-cube cube-position 2.0 2.0 2.0 :red)
	       (draw-cube-wires cube-position 2.0 2.0 2.0 :maroon)
	       (draw-grid 10 1.0))

	     (draw-rectangle 10 10 320 93 (fade :skyblue 0.5))
	     (draw-rectangle-lines 10 10 320 93 :blue)

	     (draw-text "Free camera default controls:" 20 20 10 :black)
	     (draw-text "- Mouse Wheel to Zoom in-out" 40 40 10 :darkgray)
	     (draw-text "- Mouse Wheel Pressed to Pan" 40 60 10 :darkgray)
	     (draw-text "- Z to zoom to (0, 0, 0)" 40 80 10 :darkgray))))))

(main)
