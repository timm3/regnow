require 'mechanize'
require_relative 'database_manager'

TEST_MODE = true

#TEST_URL = 'http://localhost:4567'
#TEST_URL = 'http://localhost:9292'
TEST_URL = 'http://illiniregnow.com:9292'


class CourseManager

  def initialize(netid=$netid, password=$password)
    @netid = netid
    @password = password # TODO: decrypt later

    @login_url = 'https://eas.admin.uillinois.edu/eas/servlet/EasLogin?redirect=https://webprod.admin.uillinois.edu/ssa/servlet/SelfServiceLogin?appName=edu.uillinois.aits.SelfServiceLogin&dad=BANPROD1'
    @logout_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/twbkwbis.P_Logout'
    @select_term_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfcls.p_sel_crse_search'
    @current_term_crn = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwckschd.p_disp_detail_sched?term_in=120141&crn_in='
    @add_course_url = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfreg.P_AltPin'

    @select_term_action = '/BANPROD1/bwckgens.p_proc_term_date'
    @add_course_form_action = 'https://ui2web1.apps.uillinois.edu/BANPROD1/bwckcoms.P_Regs'

    if( TEST_MODE )
      @login_url = TEST_URL + '/enterprise'
      @logout_url = TEST_URL + '/twbkwbis.P_Logout'
      @select_term_url = TEST_URL + '/select_term'
      @current_term_crn = TEST_URL + '/detailed?crn_in='
      @add_course_url = TEST_URL + '/add_drop_classes'

      @select_term_action = '/select_classes'
      @add_course_form_action = 'add_drop_classes'
    end

    @bot = Mechanize.new
  end

  # log into self-service
  def login
    page = @bot.get(@login_url)
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = @netid
    login_form.password = @password
    sleep Registration.human_delay
    page = @bot.submit(login_form, login_form.button_with(:value => 'Login'))
  end

  #chooses latest semester term. User must be logged in first
  def choose_latest_semester
    sleep Registration.human_delay
    page = @bot.get(@select_term_url)
    term_form = page.form_with(:action => @select_term_action)
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    sleep Registration.human_delay
    page = @bot.submit(term_form, term_form.button_with(:value => 'Submit'))
  end

  #logs user out of registration system
  def logout
    sleep Registration.human_delay
    page = @bot.get(@logout_url)
    logout_form = page.form_with(:action => 'logout.do')
    #pp page
    sleep Registration.human_delay
    page = @bot.submit(logout_form, logout_form.button_with(:value => 'Yes'))
  end

  #returns number of spots for a specific crn. User DOES NOT need to be logged in
  # for this to be successful
  def get_open_spots(crn)

    page = @bot.get(@current_term_crn + crn.to_s)

    #if class doesn't exist return false
    if( page.search('span.errortext').length > 0 )
      return false
    end


    remaining_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[3]').first.text
    return remaining_seats.to_i
  end

  #returns number of spots in a class for a specific crn. User DOES NOT need to be logged in
  # for this to be successful
  def get_total_spots(crn)
    if !DatabaseManager.check_crn(crn)
      return false
    end
    page = @bot.get(@current_term_crn + crn.to_s)
    total_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[2]').text
    return total_seats.to_i
  end

  #register selected student for an array of crns conccurenly
  # returns true if registration is successful, false if it failed
  def register_crn_list(crn_list)
    login
    choose_latest_semester
    page = @bot.get(@add_course_url)

    add_form = page.form_with(:action => @add_course_form_action)

    #add each crn to form
    for i in 0..crn_list.length
      add_form.field_with(:dom_id => ('crn_id'+((i+1).to_s()) ) ).value = crn_list[i]
    end

    sleep Registration.human_delay
    page = @bot.submit(add_form, add_form.button_with(:value => 'Submit Changes'))

    #if there are any add errors, return false
    if( page.search('span.errortext').length > 0 )
      logout
      return false
    end

    logout

    return true
  end

end
