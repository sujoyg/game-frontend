def with_constants(constants, &block)
  saved_constants = {}
  constants.each do |constant, val|
    saved_constants[constant] = Kernel.const_get(constant)
    Kernel::silence_warnings { Kernel.const_set(constant, val) }
  end

  begin
    block.call
  ensure
    # Restore constants.
    constants.keys.each do |constant|
      Kernel::silence_warnings { Kernel.const_set(constant, saved_constants[constant]) }
    end
  end
end

def with_environment(environment, &block)
  old_globals = $globals
  $globals = Globals.read('config/globals.yml', environment)

  block.call

  $globals = old_globals
end

def with_user(user, &block)
  with_constants ENV: {'USER' => user}, &block
end