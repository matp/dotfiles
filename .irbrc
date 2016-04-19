def time(times = 1)
  raise ArgumentError, 'no block given' unless block_given?

  require 'benchmark'
  result = nil

  if times > 1
    result = []
    Benchmark.bm {|bm| bm.report { times.times { result << yield } } }
  elsif times == 1
    Benchmark.bm {|bm| bm.report { result = yield } }
  end

  result
end
