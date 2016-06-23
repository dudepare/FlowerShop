a = [0, 0, 0, 3, 3, 5, 3, 3]
n = 7

sum = 0
skip_counter = 0
a.reverse.each do |step|
  if skip_counter == 0
    sum += step
    skip_counter = step
  else
    skip_counter -= 1
    next
  end
end
puts "#{sum == n}"