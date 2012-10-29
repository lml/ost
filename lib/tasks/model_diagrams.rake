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