require 'spec_helper'
require 'support/dummy_class'

describe MethodDecorator do

  let(:dummy_arg) { :dummy_arg }

  context 'when common class as target' do

    let(:target) { DummyClass }
    let(:target_instance) { target.new }

    context 'when public method' do

      context 'when through module singleton method' do

        before { expect(target_instance).to receive(:puts).with("a_decorated_public_instance_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("a_public_instance_method_arg: #{dummy_arg}").ordered }

        it { target_instance.a_public_instance_method dummy_arg }

      end

      context 'when through module inclusion' do

        before { expect(target_instance).to receive(:puts).with("another_decorated_public_instance_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("another_public_instance_method_arg: #{dummy_arg}").ordered }

        it { target_instance.another_public_instance_method dummy_arg }

      end

    end

    context 'when protected method' do

      context 'when calling original method through `call_original`' do

        context 'when calling protected method deliberately' do

          it { expect{target_instance.a_protected_instance_method dummy_arg}.to raise_error NoMethodError }

        end

        context 'when calling protected method through `send`' do

          before { expect(target_instance).to receive(:puts).with("a_decorated_protected_instance_method_with: #{[dummy_arg]}").ordered }
          before { expect(target_instance).to receive(:puts).with("a_protected_instance_method_arg: #{dummy_arg}").ordered }

          it { target_instance.send :a_protected_instance_method, dummy_arg }

        end

      end

      context 'when calling original method through `call_original_with`' do

        context 'when calling protected method through `send`' do

          before { expect(target_instance).to receive(:puts).with("another_decorated_protected_instance_method_with: #{[dummy_arg]}").ordered }
          before { expect(target_instance).to receive(:puts).with("another_protected_instance_method_arg: hue").ordered }

          it { target_instance.send :another_protected_instance_method, dummy_arg }

        end

      end

    end

    context 'when private method' do

      context 'when calling private method deliberately' do

        it { expect{target_instance.a_private_instance_method dummy_arg}.to raise_error NoMethodError }

      end

      context 'when calling private method through `send`' do

        before { expect(target_instance).to receive(:puts).with("a_decorated_private_instance_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("a_private_instance_method_arg: #{dummy_arg}").ordered }

        it { target_instance.send :a_private_instance_method, dummy_arg }

      end

    end

  end

  context 'when singleton class as target' do

    let(:target) { DummyClass.singleton_class }
    let(:target_instance) { DummyClass }

    context 'when public method' do

      context 'when through module singleton method' do

        before { expect(target_instance).to receive(:puts).with("a_decorated_public_singleton_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("a_public_singleton_method_arg: #{dummy_arg}").ordered }

        it { target_instance.a_public_singleton_method dummy_arg }

      end

      context 'when through module inclusion' do

        before { expect(target_instance).to receive(:puts).with("another_decorated_public_singleton_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("another_public_singleton_method_arg: #{dummy_arg}").ordered }

        it { target_instance.another_public_singleton_method dummy_arg }

      end

    end

    context 'when protected method' do

      context 'when calling protected method deliberately' do

        it { expect{target_instance.a_protected_singleton_method dummy_arg}.to raise_error NoMethodError }

      end

      context 'when calling protected method through `send`' do

        before { expect(target_instance).to receive(:puts).with("a_decorated_protected_singleton_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("a_protected_singleton_method_arg: #{dummy_arg}").ordered }

        it { target_instance.send :a_protected_singleton_method, dummy_arg }

      end

    end

    context 'when private method' do

      context 'when calling private method deliberately' do

        it { expect{target_instance.a_private_singleton_method dummy_arg}.to raise_error NoMethodError }

      end

      context 'when calling private method through `send`' do

        before { expect(target_instance).to receive(:puts).with("a_decorated_private_singleton_method_with: #{[dummy_arg]}").ordered }
        before { expect(target_instance).to receive(:puts).with("a_private_singleton_method_arg: #{dummy_arg}").ordered }

        it { target_instance.send :a_private_singleton_method, dummy_arg }

      end

    end

  end

end