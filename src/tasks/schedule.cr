require "tasker"

class Schedule
  def self.job(id : Symbol, dispatch : Symbol, time : Time, &callback : -> _)
    if dispatch == :at
      self.store[id] = Tasker.at(time, &callback)
    else
      self.usage
    end
  end

  def self.job(id : Symbol, dispatch : Symbol, time : Time::Span | String, &callback : -> _)
    case dispatch
    when :in
      self.store[id] = Tasker.in(time, &callback)
    when :every
      self.store[id] = Tasker.every(time, &callback)
    else
      self.usage
    end
  end

  def self.job(id : Symbol, dispatch : Symbol, time : String, &callback : -> _)
    if dispatch == :cron
      self.store[id] = Tasker.cron(time, &callback)
    else
      self.usage
    end
  end

  def self.finish
    self.store.each do |id, job|
      puts "Finishing job '#{id}'..."
      job.cancel
    end
    self.store.clear
    puts "Schedule finished."
  rescue error
    puts "Failed to cancel running jobs\n#{error.inspect_with_backtrace}"
  end

  def self.usage
    raise "Usage: 'Schedule.job <description>, :at|:in|:every|:cron, <time>, <block>'"
  end

  def self.store
    @@jobs ||= Hash(Symbol, Tasker::Task).new
  end
end
