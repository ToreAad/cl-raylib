(require :cl-raylib)

(defpackage :raylib-user
  (:use :cl :raylib :3d-vectors))

(in-package :raylib-user)

(defun main ()
  (let* ((max-buildings 100)
         (screen-width 800)
	 (screen-height 450)
	 (player (make-rectangle :x 400 :y 280 :width 40 :height 40))
	 (buildings (make-array max-buildings))
	 (build-colors (make-array max-buildings))
	 (spacing 0)
	 (camera (make-camera2d
		  :target (vec (+ (rectangle-x player) 20.0)
			       (+ (rectangle-y player) 20.0))
		  :offset (vec (/ screen-width 2)
			       (/ screen-width 2))
		  :rotation 0.0
		  :zoom 1.0)))

    (dotimes (i max-buildings)
      (let* ((width (get-random-value 50 200))
	     (height (get-random-value 100 800))
	     (x (- spacing 6000.0))
	     (y (- screen-height (+ 130.0 height)))
	     (building (make-rectangle :width width
				       :height height
				       :y y
				       :x x))
	     (color (make-rgba (get-random-value 200 240)
			       (get-random-value 200 240)
			       (get-random-value 200 250)
			       255)))
	(setf (elt buildings i) building)
	(incf spacing width)
	(setf (elt build-colors i) color)))
    
    (with-window (screen-width screen-height "raylib [core] example - 2d camera")
      (set-target-fps 60)	       ; Set our game to run at 60 FPS
      (loop
	until (window-should-close) ; detect window close button or ESC key
	do
	   ;; Update
	   ;; Player movement
	   (cond ((is-key-down :key-right) (incf (rectangle-x player) 2))
		 ((is-key-down :key-left) (decf (rectangle-x player) 2)))

	   ;; Camera target follows player
	   (setf (camera2d-target camera)
		 (vec (+ (rectangle-x player) 20.0)
		      (+ (rectangle-y player) 20.0)))

	   ;; Camera rotation controls
	   (cond ((is-key-down :key-a) (decf (camera2d-rotation camera)))
		 ((is-key-down :key-s) (incf (camera2d-rotation camera))))

	   ;; Limit camera rotation to 80 degrees (-40 to 40)
	   (cond ((> (camera2d-rotation camera) 40) (setf (camera2d-rotation camera) 40))
		 ((< (camera2d-rotation camera) -40) (setf (camera2d-rotation camera) -40)))

	   ;; Camera zoom controls
	   (incf (camera2d-zoom camera) (* 0.05 (get-mouse-wheel-move)))

	   (cond ((> (camera2d-zoom camera) 3.0) (setf (camera2d-zoom camera) 3.0))
		 ((< (camera2d-zoom camera) 0.1) (setf (camera2d-zoom camera) 0.1)))

	   ;; Camera reset (zoom and rotation)
	   (when (is-key-pressed :key-r)
	     (setf (camera2d-zoom camera) 1.0)
	     (setf (camera2d-rotation camera) 0.0))
	   
	   (with-drawing
	     (clear-background :raywhite)
	     (with-mode-2d (camera)
	       (draw-rectangle -6000 320 13000 8000 :darkgray)

	       (dotimes (i max-buildings)
		 (draw-rectangle-rec (elt buildings i) (elt build-colors i)))

	       (draw-rectangle-rec player :red)

	       (draw-line (floor (vx (camera2d-target camera))) (* screen-height -10)
			  (floor (vx (camera2d-target camera))) (* screen-height 10)
			  :green)

	       (draw-line (* screen-width -10) (floor (vy (camera2d-target camera)))
			  (* screen-width 10) (floor (vy (camera2d-target camera)))
			  :green))
	     
	     (draw-text "SCREEN AREA" 640 10 20 :red)

	     (draw-rectangle 0 0 screen-width 5 :red)
	     (draw-rectangle 0 5 5 (- screen-height 10) :red)
	     (draw-rectangle (- screen-width 5) 5 5 (- screen-height 10) :red)
	     (draw-rectangle 0 (- screen-height 5) screen-width 5 :red)

	     (draw-rectangle 10 10 250 113 (fade :skyblue 0.5))
	     (draw-rectangle-lines 10 10 250 113 :blue)
	     
	     (draw-text "Free 2d camera controls:" 20 20 10 :black) 
             (draw-text "- Right/Left to move Offset" 40 40 10 :DARKGRAY) 
             (draw-text "- Mouse Wheel to Zoom in-out" 40 60 10 :DARKGRAY)
             (draw-text "- A / S to Rotate" 40 80 10 :DARKGRAY) 
             (draw-text "- R to reset Zoom and Rotation" 40 100 10 :DARKGRAY))))))

(main)
