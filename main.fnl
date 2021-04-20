;; title: spirited
;; author: dawranliou
;; desc: short description
;; script: fennel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global

(var t 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dialog

;; Dialog functions from https://gitlab.com/technomancy/fennel-dialog

(var chars {})

(var coros {})

(var said nil)
(var who nil)
(var choices nil)
(var choice nil)
(var current-talk nil)

(var convos {})

(fn distance [a b]
 (let [x (- a.x b.x) y (- a.y b.y)]
  (math.sqrt (+ (* x x) (* y y)))))

(fn say [...]
 (set said (table.concat [...] "\n"))
 (coroutine.yield)
 (set said nil))

(fn ask [q ch]
 (set (said choices choice) (values q ch 1))
 (let [answer (coroutine.yield)]
  (set (said choices choice) nil)
  answer))

(var talk-range 16)

(fn find-convo [x y]
 (var target nil)
 (var target-dist talk-range)
 (var char nil)
 (each [name c (pairs chars)]
  (when (and (. convos name)
         (< (distance {:x x :y y} c)
          target-dist))
   (set target name)
   (set target-dist (distance {:x x :y y} c))
   (set char c)))
 (values (. convos target) char))

(fn choose [dir]
 (when (and current-talk choice)
  (set choice (-> (+ dir choice)
               (math.max 1)
               (math.min (# choices))))))

(fn dialog [x y act? cancel?]
 (when act?
  (if current-talk
   (do (coroutine.resume current-talk
        (and choices (. choices choice)))
    (when (= (coroutine.status current-talk)
           "dead")
     (set current-talk nil)))
   (let [(convo char) (find-convo x y)]
    (when convo
     (set current-talk (coroutine.create convo))
     (set who char)
     (coroutine.resume current-talk)))))
 (when cancel?
  (set current-talk nil))
 (and current-talk {:said said :who who :choices choices}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; characters

(var p {:x 576 :y 464 :d 0 :idle-timer 0
        :spr-idle 256 :spr-walk 258})

(set chars.ed {:x 590 :y 470 :name "ed"
               :spr 320 :spr-walk 338 :portrait 336})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; collision

(fn solid? [x y]
 "Return true if (x, y) has a solid (flagged 0) map object."
 (fget (mget (math.floor (/ x 8)) (math.floor (/ y 8))) 0))

(fn reset-idle-timer []
 (set p.idle-timer 0))

(fn move []
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; draw

(var cam {:x -400 :y -300})

(fn draw-char [c]
 (let [spr-id (+ c.spr (// (% t 60) 30))]
  (spr spr-id c.x c.y 0 1 0 0 1 1)))

(fn draw-dialog []
 (when said
  (rect 0 0 238 44 1)
  (rectb 1 1 236 42 15)
  (print said 24 6)
  (when (and who who.portrait)
   (print who.name 5 30)
   (spr who.portrait 5 10 0 1 0 0 2 2))))

;; https://github.com/nesbox/TIC-80/wiki/Camera-tutorial
(fn lerp [a b t]
 (+ (* a (- 1 t)) (* t b)))

(fn draw []
 (cls)
 (set cam.x (math.min 120 (lerp cam.x (- 120 p.x) 0.05)))
 (set cam.y (math.min 64 (lerp cam.y (- 64 p.y) 0.05)))
 (let [ccx (// (- cam.x) 8)
       ccy (// (- cam.y) 8)]
  (map ccx ccy 32 19 (- (% cam.x 8) 8) (- (% cam.y 8) 8)))
 ;; NPC
 (each [name c (pairs chars)]
  (let [x* (+ cam.x c.x)
        y* (+ cam.y c.y)]
   (spr (+ c.spr (// (% t 60) 30)) x* y* 0 1 0 0 1 1)))
 ;; Player
 (let [x* (+ p.x cam.x)
       y* (+ p.y cam.y)]
  (if (> p.idle-timer 10)
   (spr (+ p.spr-idle (// (% t 60) 30)) x* y* 0 1 p.d 0 1 1)
   (spr (+ p.spr-walk (// (% t 20) 10)) x* y* 0 1 p.d 0 1 1)))
 (draw-dialog))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; game

(fn init []
 (music 0))

(init)

(global TIC
 (fn tic []
  (draw)
  (let [talking-to (dialog p.x p.y (btnp 4) (btnp 5))]
   (if (and talking-to (btnp 0)) (choose -1)
    (and talking-to (btnp 1)) (choose 1)
    (not talking-to) (move)))
  (for [i (# coros) 1 -1]
   (coroutine.resume (. coros i))
   (when (= :dead (coroutine.status (. coros i)))
    (table.remove coros i)))
  (set t (+ t 1))))
