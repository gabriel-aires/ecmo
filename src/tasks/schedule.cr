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

  def self.finish
    store.each do |id, job|
      puts "Finishing job \"#{id}\""
      job.cancel
    end
    store.clear
    puts "Schedule finished."
  rescue error
    puts "Failed to cancel running jobs\n#{error.inspect_with_backtrace}"
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
