## 0.7

* improvement: correctly ordered log levels (now: ... warn ok section error ...)
* bugfix: don't set root log level when initializing stdout logger; make sure logging to other appenders is not affected here
* bugfix: prevent duplicate entries of stdout appender + prevent removal of other appenders when initializing zlog stdout

## 0.6

* improvement: fixed versions of gem file dependencies
* bugfix: deprecated ruby 1.9.2

## 0.5

* improvement: added test suite with rake, minitest, spec, turn and travis

## 0.4

* feature: added abort( message, exit_code ) to call a fatal log message and exit
* improvement: added changelog
* bugfix: removed highline as dependency, it is not necessary anymore

## 0.3

* feature: switched to logging framework for ruby; this is now a formatter/styler on top of it
* bugfix: removed prefix zeros from 256-colors ansi calls to blue and green

## 0.2

* improvement: made debug logging slightly lighter to be more readable
* bugfix: removed color-mode detection, using 256-colors by default now

## 0.1

* feature: initial stable release
