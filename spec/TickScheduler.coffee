Bacon = (require "../src/Bacon").Bacon
_ = Bacon._

exports.TickScheduler = ->
  counter = 0
  currentTick = 0
  schedule = {}
  toRemove = []
  nextId = -> counter++
  running = false

  add = (delay, entry) ->
    tick = currentTick + delay
    entry.id = nextId()
    schedule[tick] = [] if not schedule[tick]
    schedule[tick].push entry
    entry.id
  boot = (id) ->
    if not running
      running = true
      setTimeout run, 0
    id
  run = ->
    while Object.keys(schedule).length
      while schedule[currentTick]?.length
        forNow = schedule[currentTick].splice(0)
        for entry in forNow
          if _.contains(toRemove, entry.id)
            _.remove(entry.id, toRemove)
          else
            entry.fn()
            add entry.recur, entry if entry.recur
      delete schedule[currentTick]
  {
    setTimeout: (fn, delay) -> boot(add delay, { fn })
    setInterval: (fn, recur) -> boot(add recur, { fn, recur })
    clearTimeout: (id) -> toRemove.push(id)
  }