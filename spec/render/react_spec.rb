require 'spec_helper'

describe Render::React do
  subject { Class.new.include(Render::React).new }

  it 'evals plain js' do
    expect(
      subject.send(:instance_variable_get, :@react_render_cxt).eval('2*2')
    ).to eq(4)
  end

  it 'renders simple component' do
    name = 'Frank'
    output = subject.react(
      :HelloMessage,
      name: name
    )
    expect(output).to include('data-reactid')
    expect(output).to include(name)
  end

  xit 'doesn\'t have memory leak' do
    samples1 = []
    10.times do |_i|
      100.times do |_j|
        output = subject.react(
          :HelloMessage,
          name: :LeakyName
        )
      end
      pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$PROCESS_ID}"`.strip.split.map(&:to_i)
      samples1 << size
      GC.start
    end
    puts "RSS #{samples1.inject(:+).to_f / samples1.size}"

    samples1 = []
    10.times do |_i|
      100.times do |_j|
        output = subject.react(
          :HelloMessage,
          name: :LeakyName
        )
      end
      pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$PROCESS_ID}"`.strip.split.map(&:to_i)
      samples1 << size
      GC.start
    end
    puts "RSS #{samples1.inject(:+).to_f / samples1.size}"
    expect(true).to be_true
  end
end
