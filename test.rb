test = {'BarryWhite'=>[{ "age" => '12', :height => '45cm'  },{ "age" => '34', :height => '108cm' }],'AndyMurray' => [{ "age" => '14', :height => '125cm' }]}

stats = test['BarryWhite'].first["age"]

p stats
