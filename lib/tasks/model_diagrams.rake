# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

namespace :diagram do
    namespace :model do
        task :pretty_png do
            sh "railroady -M --hide-magic | dot -Tpng > doc/module_pretty.png"
        end

        task :pretty_svg do
            sh "railroady -M --hide-magic | dot -Tsvg > doc/module_pretty.svg"
        end
    end
end