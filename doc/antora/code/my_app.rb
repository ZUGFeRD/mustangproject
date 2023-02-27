# This file represents "software".
# This file helps show that documentation files can be in the same repository as software.

rescue => ex
  begin
    context = %(asciidoctor: FAILED: #{attrs['docfile'] || '<stdin>'}: Failed to load AsciiDoc document)
    if ex.respond_to? :exception
      # The original message must be explicitely preserved when wrapping a Ruby exception
      wrapped_ex = ex.exception %(#{context} - #{ex.message})
      # JRuby automatically sets backtrace, but not MRI
      wrapped_ex.set_backtrace ex.backtrace
    else
      # Likely a Java exception class
      wrapped_ex = ex.class.new context, ex
      wrapped_ex.stack_trace = ex.stack_trace
    end
  rescue
    wrapped_ex = ex
  end
  raise wrapped_ex
end
