Pod::Spec.new do |s|

  s.name         = "TieApiClient"
  s.version      = "1.1.0"
  s.summary      = "Provides a way of communicating with a Teneo Engine server instance"
  s.description  = <<-DESC
                  Provides a way of communicating with a Teneo Engine server instance

                  Usage:
                  ```swift
                  // Set Teneo engine url
                  try {
                      TieApiService.sharedInstance.setup("{BASE_URL}", endpoint: "{ENDPOINT}")
                  } catch {
                      // Handle TieSetupError.invalidUrl
                  }
              
                  // Send input messages
                  TieApiService.sharedInstance.sendInput({MESSAGE},
                                                         parameters: {PARAMETERS},
                                                         success: { response in
                      // Handle response. Remember to dispatch to main thread if updating UI
                  }, failure: { error in
                      // Handle error
                  })
              
                  // Close session
                  TieApiService.sharedInstance.closeSession({ response in
                      //
                  }, failure { error in
              
                  })
                  ```
                  DESC
  s.homepage     = "https://www.artificial-solutions.com/teneo/teneo-interaction-engine"

  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = "Artificial Solutions"

  s.swift_version = "4.2"
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/artificialsolutions/tie-api-client-ios.git", :tag => "#{s.version}" }
  s.source_files  = "TieApiClient", "TieApiClient/**/*.{swift}"

end
