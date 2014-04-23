require '../app'
require 'test/unit'
require 'rack/test'

class RegNowDatabaseTest < Test::Unit::TestCase

  def test_register_from_queues()
    user = User.first(:netid => 'student_reg_test')

    if( user == nil)
      user = User.create(:netid => 'student_reg_test')
    end

    user[:adPassword] = 'reg_password'

    Registration.update_queues

    assert 


  end

end
