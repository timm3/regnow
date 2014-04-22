require 'mechanize'
require_relative 'database_manager'

TEST_MODE = true

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
      @login_url = 'http://localhost:4567/enterprise'
      @logout_url = 'http://localhost:4567/logout.do'
      @select_term_url = 'http://localhost:4567/select_term'
      @current_term_crn = 'http://localhost:4567/detailed?crn_in='
      @add_course_url = 'http://localhost:4567/add_drop_classes'

      @select_term_action = '/select_classes'
      @add_course_form_action = 'add_drop_classes'
    end

    @bot = Mechanize.new
  end

  # log into self-service and chooses latest semester term
  def login
    page = @bot.get(@login_url)
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = @netid
    login_form.password = @password
    sleep Registration.human_delay
    page = @bot.submit(login_form, login_form.button_with(:value => 'Login'))
  end

  def choose_latest_semester
    sleep Registration.human_delay
    page = @bot.get(@select_term_url)
    term_form = page.form_with(:action => @select_term_action)
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    sleep Registration.human_delay
    page = @bot.submit(term_form, term_form.button_with(:value => 'Submit'))
  end

  def logout
    sleep Registration.human_delay
    page = @bot.get(@logout_url)
    logout_form = page.form_with(:action => 'logout.do')
    #pp page
    #sleep 1
    #page = @bot.submit(logout_form, logout_form.button_with(:value => 'Yes'))
  end

  def get_open_spots(crn)
=begin
    options_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse')
    page = @bot.submit(options_form, options_form.button_with(:value => 'Advanced Search'))
    crn_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse_Advanced')
    crn_form.crn = crn
    page = @bot.submit(crn_form, crn_form.button_with(:name => 'SUB_BTN'))
=end
    if !DatabaseManager.check_crn(crn)
      return false
    end
    page = @bot.get(@current_term_crn + crn.to_s)
    remaining_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[3]').first.text
    return remaining_seats.to_i
  end

  def get_total_spots(crn)
    if !DatabaseManager.check_crn(crn)
      return false
    end
    page = @bot.get(@current_term_crn + crn.to_s)
    total_seats = page.search('/html/body/div[3]/table[1]/tr[2]/td/table/tr[2]/td[2]').text
    return total_seats.to_i
  end

  def register_crn_list(crn_list)

    #TODO figure out how to check that CRN exists for testing

    #for crn in crn_list
    #  if !DatabaseManager.check_crn(crn)
    #    return false
    #  end
    #end

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
      #TODO: logout
      #logout
      return false
    end

    #TODO: this is generating an error in tests for some reason
    #logout

    return true
  end

  def can_register(crn)

    # TODO: returns if user can or cannot register for course

  end
end
