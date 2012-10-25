# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    sequence(:url)  {|n| "http://exercise.com/#{n}"}
    is_dynamic      false
    content_cache   %q({"simple_question":{"id":"q311v1","url":"http://quadbase.org/questions/q311v1","introduction":{"markup":"Summation of a geometric series","html":"<p>Summation of a geometric series</p>"},"content":{"markup":"Calculate $\\sum_{k=0}^\\infty\\alpha^k$ for a complex number $|\\alpha|<1$.\r\n","html":"<p>Calculate $\\sum_{k=0}^\\infty\\alpha^k$ for a complex number $|\\alpha|<1$.</p>"},"answer_choices":[{"markup":"$\\frac{1}{1-\\alpha}$","html":"<p>$\\frac{1}{1-\\alpha}$</p>","credit":1},{"markup":"$\\frac{\\alpha}{1-\\alpha}$","html":"<p>$\\frac{\\alpha}{1-\\alpha}$</p>","credit":0},{"markup":"$\\alpha$","html":"<p>$\\alpha$</p>","credit":0}],"answer_can_be_sketched":null,"attribution":{"authors":[{"id":9,"name":"Daniel Williamson"}],"copyright_holders":[{"id":9,"name":"Daniel Williamson"}],"license":{"name":"Creative Commons Attribution 3.0 Unported","url":"http://creativecommons.org/licenses/by/3.0/"}}}})
  end
end
