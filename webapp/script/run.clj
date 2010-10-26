(use 'ring.adapter.jetty)
(require 'poeticc.core)

(run-jetty #'poeticc.core/app {:port 3000})