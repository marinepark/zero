require 'spec_helper'

describe Zero::Renderer, '#render' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) {{
    'html' => ['text/html', 'text/xml', '*/*'],
    'json' => ['application/json', 'plain/text']
  }}
  let(:html_types) { ['text/html'] }
  let(:json_types) { ['application/json'] }
  let(:foo_types)  { ['foo/bar', 'bar/foo'] }
  let(:binding) { SpecTemplateContext.new('foo') }

  it 'returns a tilt template' do
    expect(subject.render_partial('index', html_types, binding)
          ).to be_kind_of(String)
  end

  it 'renders html content' do
    expect(subject.render_partial('index', html_types, binding)
          ).to match('success')
  end

  it 'returns a tilt template for different types' do
    expect(subject.render_partial('index', json_types, binding)
          ).to be_kind_of(String)
  end

  it 'renders json content' do
    expect(subject.render_partial('index', json_types, binding)
          ).to match("{text: 'success'}")
  end

  it 'returns an ArgumentError, if given template does not exist' do
    expect {
      subject.render_partial('foobar', html_types, binding)
    }.to raise_error(ArgumentError, /Template 'foobar' does not exist/)
  end

  it 'returns an ArgumentError, if no template fits types' do
    expect {
      subject.render_partial('index', foo_types, binding)
    }.to raise_error(
      ArgumentError, /Template 'index' not found/)
  end

  it 'uses the context' do
    expect(subject.render_partial('context', html_types, binding)
          ).to match('foo')

  end
end
