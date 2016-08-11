require 'spec_helper'

describe Render::React do
  subject do
    klass = Class.new.include(Render::React)
    klass.render_react_from FIXTURES_PATH
    klass.new
  end

  it 'evals plain js' do
    expect(
      subject.send(:instance_variable_get, :@react_render_cxt).eval('2*2')
    ).to eq(4)
  end

  it 'renders simple component' do
    name = 'Frank'
    output = subject.render_react(
      :HelloMessage,
      name: name
    )
    expect(output).to include('data-reactid')
    expect(output).to include(name)
  end

  it 'doesn\'t have memory leaks' do
    samples = []
    10.times do |_i|
      1000.times do |_j|
        output = subject.render_react(
          :HelloMessage,
          name: :LeakyName
        )
      end
      ps = `ps ax -o pid,rss | grep -E "^[[:space:]]+#{$$}"`.strip
      pid, size = ps.split.map(&:to_i)
      samples << size
    end
    average = samples.inject(:+).to_f / samples.size
    expect(average < samples.first).to be_truthy
  end
end
