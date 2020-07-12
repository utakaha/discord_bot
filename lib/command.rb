# frozen_string_literal: true

def choice(args)
  args.length == 1 ? args.first.split('　').sample : args.sample
end
