shared_examples_for 'email validation examples' do
  context 'valid email' do
    before do
      subject.email = 'valid@mail.com'
      subject.valid?
    end
    it 'should be valid' do
      expect(subject.valid?).to be_truthy
    end
  end
  context 'invalid email' do
    before do
      subject.email = 'invalid'
      subject.valid?
    end
    it 'should have valid validation error' do
      expect(subject.errors.full_messages).to include('Email has incorrect email format')
    end
  end
end
