require 'spec_helper'

describe Render::React do
  subject { Class.new.include(Render::React).new }

  it '#render_react_eval_js evals plain js' do
    expect(subject.render_react_eval_js('2*2')).to eq(4)
  end

  it '#react renders simple component' do
    name = "Frank"
    output = subject.react(
      :HelloMessage,
      "#{FIXTURES_PATH}/component.js",
      name: name
    )
    expect(output).to include("data-reactid")
    expect(output).to include(name)
  end
end
