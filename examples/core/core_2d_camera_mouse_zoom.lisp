(require :cl-raylib)

(defpackage :raylib-user
  (:use :cl :raylib :3d-vectors))

(in-package :raylib-user)

(defun clamp (value min max)
  (cond
    ((< value min) min)
    ((> value max) max)
    (t value)))

(defun main ()
  (let ((screen-width 800)
        (screen-height 450)
	(camera (make-camera2d :target (vec 0 0) :offset (vec 0 0) :rotation 0.0 :zoom 1.0 ))
	(zoom-mode 0)) 			;; 0-Mouse Wheel, 1-Mouse MOve
    (with-window (screen-width screen-height "raylib [core] example - basic window")
      (set-target-fps 60)	       ; Set our game to run at 60 FPS
      (loop
        until (window-should-close) ; detect window close button or ESC key
        do
	   (cond ((is-key-down :key-one) (setf zoom-mode 0))
		 ((is-key-down :key-two) (setf zoom-mode 1)))

	   ;; Translate based on mouse right click
	   (when (is-mouse-button-down :mouse-button-left)
	     (let* ((delta (v* (get-mouse-delta)
			       (/ -1.0 (camera2d-zoom camera)))))
	       (setf (camera2d-target camera) (v+ (camera2d-target camera) delta))))

	   (if (= zoom-mode 0)
	       ;;  Zoom based on mouse wheel
	       (let ((wheel (get-mouse-wheel-move)))
		 (unless (= wheel 0)
		   (let ((mouse-world-pos (get-screen-to-world-2d (get-mouse-position)
								  camera))
			 ;; Zoom increment
			 (scale-factor (+ 1.0 (* 0.25 (abs wheel)))))
		     ;; Set the offset to where the mouse is
		     (setf (camera2d-offset camera) (get-mouse-position))

		     ;;  Set the target to match so that the camera maps the world space
		     ;; point under the cursor to the screen space point under the cursor
		     ;; at any zoom
		     (setf (camera2d-target camera) mouse-world-pos)
		     (when (< wheel 0)
		       (setf scale-factor (/ 1.0 scale-factor)))
		     (setf (camera2d-zoom camera)
			   (clamp (* (camera2d-zoom camera) scale-factor)
				  0.125 64.0)))))
	       (progn
		 ;; Zoom based on mouse right click
		 (when (is-mouse-button-pressed :mouse-button-right)
		   ;; Set the target so that the camera mapts to the world space point under
		   ;; the cursor to the screen space point under cursor at any zoom
		   (setf (camera2d-target camera)
			 (get-screen-to-world-2d (get-mouse-position) camera))
		   ;; Set the offset to whre the mouse is
		   (setf (camera2d-offset camera) (get-mouse-position)))
		 (when (is-mouse-button-down :mouse-button-right)
		   (let* ((delta-x (vx (get-mouse-delta)))
			  ;; zoom increment
			  (scale-factor (+ 1.0 (* 0.01 (abs delta-x)))))
		     (when (< delta-x 0)
		       (setf scale-factor (/ 1.0 scale-factor)))
		     (setf (camera2d-zoom camera)
			   (clamp (* (camera2d-zoom camera) scale-factor)
				  0.125 64.0))))))
	   (with-drawing
	     (clear-background :raywhite)
	     (with-mode-2d (camera)
	       ;; Draw the 3d grid, rotated 90 degrees and centered around 0.0
	       ;; just so we have something in the XY plane.
	       (rlgl:push-matrix)
	       (rlgl:translate-f 0.0 (* 25.0 50.0) 0.0)
	       (rlgl:rotate-f 90.0 1.0 0.0 0.0)
	       (draw-grid 100 50.0)
	       (rlgl:pop-matrix)

	       ;; Draw a reference circle
	       (draw-circle (/ (get-screen-width) 2) (/ (get-screen-height) 2) 50.0 :maroon))

	     ;; Draw mouse reference
	     (draw-circle-v (get-mouse-position) 4.0 :darkgray)
	     (draw-text-ex (get-font-default) (format nil "[~d ~d]" (get-mouse-x) (get-mouse-y))
			   (v+ (get-mouse-position) (vec -44 -24)) 20.0 2.0 :black)
	     (draw-text "[1][2] Select mouse zoom mode (Wheel or Move)" 20 20 20 :darkgray)
	     (if (= zoom-mode 0)
		 (draw-text "Mouse left button drag to move, mouse wheel to zoom"
			    20 50 20 :darkgray)
		 (draw-text "Mouse left button drag to move, mouse press and move to zoom"
			    20 50 20 :darkgray)))))))

(main)

