require 'spec_helper'

describe CaptainHoog::Hoogfile do
  let(:path) do
    File.expand_path(File.join(File.dirname(__FILE__),
                              '..', '..','fixtures'))
  end

  let(:plugins_dir) do
    File.expand_path(File.join(File.dirname(__FILE__),
                              '..', '..','fixtures', 'plugins'))
  end

  describe 'class methods' do
    it 'provides .read' do
      expect(described_class).to respond_to(:read)
    end

    it 'provides .config' do
      expect(described_class).to respond_to(:config)
    end

    describe '.new' do
      it 'is not callable' do
        expect do
          described_class.new
        end.to raise_error NoMethodError
      end
    end

    describe '.read' do

      subject{ described_class.read(path) }

      it 'returns an instance of Hoogfile' do
        expect(subject).to be_instance_of(CaptainHoog::Hoogfile)
      end

      it 'evaluates erb' do
        expect(subject.plugins_dir).to include(plugins_dir)
      end
    end

    describe 'instance methods' do

      subject{ described_class.read(path) }

      it 'provides #fetch' do
        expect(subject).to respond_to(:fetch)
      end

      describe 'fetch' do
        it 'returns the value for a given key' do
          expect(subject.fetch(:plugins_dir)).to include(plugins_dir)
        end

        it 'returns default value if give isnt found' do
          expect(subject.fetch(:foo, [])).to eq []
        end

        it 'raises an error if no default value is given and key not exists' do
          expect do
            subject.fetch(:foo)
          end.to raise_error IndexError
        end
      end
    end
  end
end
