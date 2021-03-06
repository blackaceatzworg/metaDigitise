
context("Check calibrate_coords...")

test_that("Checking cal_coords..", {
		
	with_mock(
		locator = mockery::mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="scatterplot"), 
			data.frame(x=c(0,0,0,100),y=c(0,100,0,0)), 
			info = "cal_coords failed"
		)
	)

	with_mock(
		locator = mockery::mock(list(x=c(0,0),y=c(0,100)), list(x=c(0,100),y=c(0,0))),
		expect_equal(
			cal_coords(plot_type="mean_error"), 
			data.frame(x=c(0,0),y=c(0,100)), 
			info = "cal_coords failed"
		)
	)
})


	
test_that("Checking getVals..", {
		
	with_mock(
		`metaDigitise::user_numeric` = mockery::mock(1,2,3,4),
		expect_equal(
			getVals(calpoints=data.frame(x=c(0,0,0,100),y=c(0,100,0,0))), 
			c(y1=1,y2=2,x1=3,x2=4), 
			info = "getVals failed"
		)
	)

	with_mock(
		`metaDigitise::user_numeric` = mockery::mock(1,2,3,4),
		expect_equal(
			getVals(calpoints=data.frame(x=c(0,0),y=c(0,100))), 
			c(y1=1,y2=2), 
			info = "getVals failed"
		)
	)
})



test_that("Checking user_calibrate..", {
	with_mock(
		`metaDigitise::internal_redraw` = function(...){},
		`metaDigitise::print_cal_instructions` = function(...){},
		`metaDigitise::cal_coords` = function(...) data.frame(x=c(0,0,0,100),y=c(0,100,0,0)),
		`metaDigitise::getVals` = function(...) c(y1=1,y2=2,x1=3,x2=4),
		readline = function(...) "n",
		expect_equal(
			user_calibrate(object=list()),
			list(calpoints=data.frame(x=c(0,0,0,100),y=c(0,100,0,0)), point_vals=c(y1=1,y2=2,x1=3,x2=4)), 
			info = "user_calibrate failed"
		)
	)

})

