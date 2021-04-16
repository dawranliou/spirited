;; title: spirited
;; author: dawranliou
;; desc: short description
;; script: fennel

(var init? true)
(var t 0)
(local p {:x 96 :y 24 :d 0 :idle-timer 0})
(local c {:x 100 :y 50 :d 0})

(fn solid? [x y]
 "Return true if (x, y) has a solid (flagged 0) map object."
 (fget (mget (math.floor (/ x 8)) (math.floor (/ y 8))) 0))

(fn reset-idle-timer []
 (set p.idle-timer 0))

(fn control []
 (if (or (btn 0) (btn 1) (btn 2) (btn 3))
  (do
   ;; UP
   (when (and
          (btn 0)
          (not (solid? p.x (- p.y 1)))
          (not (solid? (+ p.x 7) (- p.y 1))))
    (set p.y (- p.y 1))
    (reset-idle-timer))
   ;; DOWN
   (when (and
          (btn 1)
          (not (solid? p.x (+ p.y 8)))
          (not (solid? (+ p.x 7) (+ p.y 8))))
    (set p.y (+ p.y 1))
    (reset-idle-timer))
   ;; LEFT
   (when (and
          (btn 2)
          (not (solid? (- p.x 1) p.y))
          (not (solid? (- p.x 1) (+ p.y 7))))
    (set p.x (- p.x 1))
    (set p.d 1)
    (reset-idle-timer))
   ;; Right
   (when (and
          (btn 3)
          (not (solid? (+ p.x 8) p.y))
          (not (solid? (+ p.x 8) (+ p.y 7))))
    (set p.x (+ p.x 1))
    (set p.d 0)
    (reset-idle-timer)))
  (set p.idle-timer (+ 1 p.idle-timer))))

(fn draw-player []
 (if (> p.idle-timer 10)
  (spr (+ 256 (// (% t 60) 30)) p.x p.y 0 1 p.d 0 1 1)
  (spr (+ 258 (// (% t 20) 10)) p.x p.y 0 1 p.d 0 1 1)))

(fn draw-cat []
 (spr (+ 320 (// (% t 60) 30)) c.x c.y 0 1 c.d 0 1 1))

(fn advance-game []
 (set t (+ t 1)))

(fn initialize []
 (music 0)
 (set init? false))

(global TIC
 (fn tic []
  (when init?
   (initialize))

  (control)

  (cls 0)
  (map)
  (draw-player)
  (draw-cat)
  ;; (print p.idle-timer 0 0)

  (advance-game)))
