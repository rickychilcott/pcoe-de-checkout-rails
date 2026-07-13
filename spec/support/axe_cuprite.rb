# Cuprite isn't Selenium. axe-core-api >= 4.3 assumes Selenium twice over:
# runPartial mode drives the browser via Selenium-only window APIs (disabled
# with legacy_mode), and audit() calls execute_async_script_fixed, which
# unwraps to the raw browser and needs native execute_async_script. Route it
# back through the gem's own execute_script + polling polyfill — the exact
# code path axe-core-api 4.2.0 (our previous pin) used.
# ponytail: monkey-patch over forking the gem; the axe system specs fail
# loudly if a future axe bump changes these internals.
Axe::Configuration.instance.legacy_mode = true

module WebDriverScriptAdapter
  class ExecuteAsyncScriptAdapter
    def execute_async_script_fixed(script, *args)
      execute_async_script(script, *args)
    end
  end
end

module Axe
  module API
    class Run
      private

      # 4.12's inline script is multi-statement (cuprite evaluates in
      # expression position) and its js_args are raw Ruby hashes (Selenium
      # marshals those natively; string interpolation renders Ruby syntax).
      # This is 4.2.0's audit path verbatim: single expression, JSON args.
      def audit(page)
        args = [@context, @options].reject { |o| o.to_h.empty? }.map(&:to_json)
        page.execute_async_script "#{METHOD_NAME}.apply(#{Core::JS_NAME}, arguments)", *args
      end
    end
  end
end
