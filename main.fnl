;; title: spirited
;; author: dawranliou
;; desc: short description
;; script: fennel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; global

(var t 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dialog

(local chars {})

(local coros {})

(var said nil)
(var who nil)
(var choices nil)
(var choice nil)
(var current-talk nil)

(local convos {})

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

(local talk-range 16)

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

(local p {:x 96 :y 24 :d 0 :idle-timer 0})
(local c {:x 100 :y 50 :d 0})

(set chars.ed {:x 100 :y 50 :name "ed"
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

(var camera-x p.x)
(var camera-y p.y)

(fn draw-char [c]
 (let [spr-id (+ c.spr (// (% t 60) 30))]
  (spr spr-id c.x c.y 0 1 0 0 1 1)))

(fn draw-dialog []
 (when said
  ;; (rect 0 0 238 44 1)
  (rectb 1 1 236 42 15)
  (print said 24 6)
  (when (and who who.portrait)
   (print who.name 5 30)
   (spr who.portrait 5 10 0 1 0 0 2 2))))

(fn lerp [a b t]
  (+ (* a (- 1 t)) (* t b)))

(fn draw []
 (cls)
 (set camera-x (math.min 120 (lerp camera-x (- 120 p.x) 0.05)))
 (set camera-y (math.min 64 (lerp camera-y (- 64 p.y) 0.05)))
 (map (// (- camera-x) 8) (// (- camera-y) 8)
  32 19 (- (% camera-x 8) 8)
  (- (% camera-y 8) 8) 0)
 ;; NPC
 (each [name c (pairs chars)]
  (let [x* (+ camera-x c.x)
        y* (+ camera-y c.y)]
   (spr (+ c.spr (// (% t 60) 30)) x* y* 0 1 0 0 1 1)))
 ;; player
 (let [x* (+ camera-x p.x)
       y* (+ camera-y p.y)]
  (if (> p.idle-timer 10)
   (spr (+ 256 (// (% t 60) 30)) x* y* 0 1 p.d 0 1 1)
   (spr (+ 258 (// (% t 20) 10)) x* y* 0 1 p.d 0 1 1)))
 (draw-dialog))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; game

(var init? true)

(fn advance-game []
 (set t (+ t 1)))

(fn initialize []
 (set said "Good morning Spirit!")
 (set who chars.ed)
 (music 0)
 (set init? false))

(global TIC
 (fn tic []
  (when init?
   (initialize))

  (draw)

  (move)

  (advance-game)))
