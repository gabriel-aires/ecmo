require "tasker"

class Schedule
  def self.job(id : Symbol | String, dispatch : Symbol, time : Time, &callback : -> _)
    if dispatch == :at
      store[id] = Tasker.at(time, &callback)
    else
      usage
    end

    call_msg id, dispatch, time
  end

  def self.job(id : Symbol | String, dispatch : Symbol, time : Time::Span | String, &callback : -> _)
    case dispatch
    when :in
      store[id] = Tasker.in(time, &callback)
    when :every
      store[id] = Tasker.every(time, &callback)
    else
      usage
    end

    call_msg id, dispatch, time
  end

  def self.job(id : Symbol | String, dispatch : Symbol, time : String, &callback : -> _)
    if dispatch == :cron
      store[id] = Tasker.cron(time, &callback)
    else
      usage
    end

    call_msg id, dispatch, time
  end

  def self.cancel(id : Symbol | String)
    if store.has_key? id
      puts "Finishing job \"#{id}\""
      job = store[id]
      job.cancel
      store.delete id
    else
      puts "Failed to cancel job. Unknown task: #{id}"
    end

    if store.empty?
      puts "Schedule finished."
    end
  end

  def self.finish
    tasks = store.keys
    tasks.each { |id| cancel id }
  end

  def self.usage
    raise "Usage: 'Schedule.job <description>, :at|:in|:every|:cron, <time>, <block>'"
  end

  def self.store
    @@jobs ||= Hash(Symbol | String, Tasker::Task).new
  end

  def self.call_msg(id, dispatch, time)
    puts "Calling job \"#{id}\" (#{dispatch} #{time})"
  end
end
