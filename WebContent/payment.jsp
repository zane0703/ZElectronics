<%@page import="sg.com.zElectronics.model.valueBean.Country"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="org.apache.commons.text.StringEscapeUtils,sg.com.zElectronics.model.valueBean.Cart,java.util.*,sg.com.zElectronics.model.valueBean.User"%>
<%!public void jspInit() {
		headerInit();
	}
	private final java.text.DecimalFormat format = new java.text.DecimalFormat();%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Payment</title>
<script src="script/FormValidation.js"></script>
<%@include file="header.jsp"%>
<%
	@SuppressWarnings("unchecked")
	ArrayList<Cart> carts = (ArrayList<Cart>) request.getAttribute("cart");
if (carts == null) {
	response.sendError(404, " The requested resource [" + request.getRequestURI() + "] is not available");
	return;
}
User user = (User)request.getAttribute("userInfo");
Country[] countries = (Country[]) request.getAttribute("countries");
StringBuilder countriesOption = new StringBuilder();
for (Country country:countries) {
	String code = country.getAlpha3Code();
	countriesOption.append("<option value=\"");
	countriesOption.append(code);
	countriesOption.append('"');
	if (code.equals(user.getCountry())) {
		countriesOption.append("selected");
	}
	countriesOption.append('>');
	countriesOption.append(country.getName());
	countriesOption.append("</option>");
}
%>
<div class="container-fluid">
	<div class="row mt-2">
		<div class="col-lg-8">
			<div class="container-fluid">
				<form name="myForm" action="javascript:checkout()">
					<div class="row">
						<div class="col">
							<h3>Billing Address</h3>
							<div class="form-group">
								<label for="nameinput">Billing Address:</label> <input
									type="text" name="address" id="adr" class="form-control"
									value="<%=StringEscapeUtils.escapeHtml4(user.getAddress()) %>" placeholder="Please Enter Your Billing Address" required />
							</div>
							<div class="form-group">
								<label for="billCountry">Country:</label> <select
									id="billCountry" class="form-control" autocomplete="country">
									<%=countriesOption%>
								</select>
							</div>
							<div class="form-group">
								<label for="postal">Postal Code:</label> <input type="text"
									autocomplete="postal-code" name="postal" id="postal"
									class="form-control" value="<%=user.getPostalCode()%>" placeholder="Please Enter Your State"
									required />
									<div class="invalid-feedback">Postal code must be a number</div>
							</div>
						</div>

						<div class="col">
							<h3>Payment</h3>
							<div class="form-group">
								<label for="nameinput">Name on Card:</label> <input type="text"
									name="ccname" id="ccname" class="form-control"
									autocomplete="cc-name"
									placeholder="Please Enter Your Full Name as Stated on Your Card"
									required />
							</div>
							<div class="form-group">
								<label for="nameinput">Credit Card Number:</label> <input
									type="text" name="ccnum" id="ccnum" class="form-control"
									placeholder="e.g. 1111-2222-3333-4444" autocomplete="cc-number"
									required />
									<div class="invalid-feedback">Invalid Credit Card Number</div>
							</div>
							<div class="form-group">
								<label for="expmonth">Expiration Month:</label> <select
									autocomplete="cc-exp-month" class="form-control" id="expmonth"
									name="expmonth" required>
									<option value="0" selected>January</option>
									<option value="1">February</option>
									<option value="2">March</option>
									<option value="3">April</option>
									<option value="4">May</option>
									<option value="5">June</option>
									<option value="6">July</option>
									<option value="7">August</option>
									<option value="8">September</option>
									<option value="9">October</option>
									<option value="10">November</option>
									<option value="11">December</option>
								</select>
								<div class="invalid-feedback">Your card have expired</div>
							</div>
							<div class="form-group">
								<label for="expyear">Expiration Year:</label> <input
									type="number" autocomplete="cc-exp-year" name="expyear"
									id="expyear" class="form-control"
									placeholder="Please Enter the Year Your Card Expires" required />
									<div class="invalid-feedback">Your card have expired</div>
							</div>
							<div class="form-group">
								<label for="nameinput">CVV:</label> <input type="text"
									name="cvv" autocomplete="cc-csc" id="cvv" class="form-control"
									placeholder="Enter the 3 Digits at the Back of Your Card"
									required />
									<div class="invalid-feedback">CCV can only be 3 digi number</div>
							</div>
						</div>
					</div>
					<div class="row" id="shipping">
						<div class="col">
							<h3>Shipping Address</h3>
							<div class="form-group">
								<label for="nameinput">Shipping Address:</label> <input
									type="text" name="shipaddress" id="shipadr"
									class="form-control"
									placeholder="Please Enter Your Billing Address" required />
							</div>
							<div class="form-group">
								<label for="shipCountry">Country:</label> <select
									id="shipCountry" class="form-control" autocomplete="country">
									<%=countriesOption%>
								</select>
							</div>
							<div class="form-group">
								<label for="shipPostal">Postal Code:</label> <input type="text"
									autocomplete="postal-code" name="shipPostal" id="shipPostal"
									class="form-control" placeholder="Please Enter Your State"
									required />
									<div class="invalid-feedback">Postal code must be a number</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="form-group">
							<input type="checkbox" name="sameadr" id="sameadr"> <label>Shipping
								address same as billing</label>
						</div>
					</div>
					<input type="submit" value="Continue to Checkout"
						class="btn btn-success">
				</form>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="container" id="subtotal">
				<h4>Cart</h4>
				<%
					double total = 0;
				for (Cart cart : carts) {
					int qty = cart.getQuantity();
					double itotal = cart.getProductRetailPrice() * 100 * qty;
					total += itotal;
				%>
				<p><%=StringEscapeUtils.escapeHtml4(cart.getProductTitle()) %>
					x<%=qty%>
					<%=currency+format.format(itotal / 100)%></p>
				<%
					}
				double subTotal = ((double) Math.round(total / 1.07)) / 100;
				%>
				<p>
					Sub Total: <%=currency+format.format(subTotal)%></p>
				<p>
					GST 7%: <%=currency+format.format(((double) Math.round((subTotal * 0.07) * 100)) / 100)%></p>
				<p>
					Total: <%=currency+format.format(total / 100)%></p>
			</div>
		</div>
		<div class="col"></div>
	</div>

</div>
<button id="top" title="Go to top">&#8593;</button>
<%@include file="footer.html" %>
<script>
        const ADDRESS = document.getElementById("adr");
        const COUNTRY =document.getElementById("billCountry")
        const POSTAL = document.getElementById('postal');
        const CCNAME = document.getElementById("ccname");
        const CCNUM = document.getElementById("ccnum");
        const EXP_MONTH = document.getElementById("expmonth");
        const EXP_YEAR = document.getElementById("expyear");
        const CVV = document.getElementById("cvv");
        const SHIP_ADDRESS = document.getElementById("shipadr")
        const SHIP_POSTAL = document.getElementById("shipPostal")
        const SHIP_COUNTRY = document.getElementById("shipCountry")
        const SAME = document.getElementById("sameadr")
        const SHIPPING =document.getElementById("shipping")
        EXP_YEAR.min = new Date().getFullYear()
        SAME.onchange=function(){
            if(SAME.checked){
            	SHIP_ADDRESS.required =false;
            	SHIP_POSTAL.required =false;
                SHIPPING.style.display="none"
            }else{
            	SHIP_ADDRESS.required =true;
            	SHIP_POSTAL.required =true;
                SHIPPING.style.display="block"
            }
        }
        function checkout() {
        	CCNUM.value = CCNUM.value.replace(/-|\s/g,"")
            foc = null
            massage = []
            Valid = true
            inputMark = !inputMark;
            isNumeric(POSTAL, "Postal code must be a number")
            isNumeric(CVV, "CCV must be a number")
            isLengthMinMax(CVV, "CCV can only be 3 digi", 3, 3)
            isCreditCardNumber(CCNUM, "Invalid Credit Card Number")
            let expDate = new Date();
            expDate.setHours(0, 0, 0, 0);
            expDate.setFullYear(parseInt(EXP_YEAR.value), parseInt(EXP_MONTH.value), 0)
            if(expDate<new Date()){
            	Valid = false;
            	EXP_YEAR.classList.remove("is-valid");
            	EXP_MONTH.classList.remove("is-valid");
            	EXP_YEAR.classList.add("is-invalid");
            	EXP_MONTH.classList.add("is-invalid");
            }else{
            	EXP_YEAR.classList.remove("is-invalid");
            	EXP_MONTH.classList.remove("is-invalid");
            	EXP_YEAR.classList.add("is-valid");
            	EXP_MONTH.classList.add("is-valid");
            }
            if (!SAME.checked) {
                isNumeric(SHIP_POSTAL, "Postal code must be a number")
            }
            if(Valid){
            swal({
                title: 'Are you sure you want checkout now ?',
                icon: 'warning',
                buttons: ['Cancel', 'Checkout']
            }).then(resolve => {
                if (resolve) {
                    let data = new URLSearchParams();
                    data.append("expDate", expDate.getTime().toString())
                    data.append("address", ADDRESS.value)
                    data.append("postal", POSTAL.value)
                    data.append("ccname", CCNAME.value)
                    data.append("ccnum", CCNUM.value.replace("-", ""))
                    data.append("cvv", CVV.value)
                    data.append("country",COUNTRY.value)
                    if (SAME.checked) {
                        data.append("sameadr", "1")
                    } else {
                        data.append("sameadr", "0")
                        data.append("shipaddress", SHIP_ADDRESS.value)
                        data.append("shipPostal", SHIP_POSTAL.value)
                        data.append("shipCountry",SHIP_COUNTRY.value)
                    }
                    swal({
                        title: "Loading...",
                        icon: "<%=contextPath%>/img/loading.gif",
                        buttons: false,
                    });
                    fetch("<%=contextPath%>/api/orders", {
                        method: "POST",
                        body: data
                    }).then(res => {
                        if (res.ok) {
                            swal({
                                icon: "success",
                                title: "You have successfully checkout your order"
                            }).then(() => {
                                window.location.href = '<%=contextPath%>'
                            })
                        } else {
                            swal({
                                icon: "error",
                                title: "Look like something went wrong",
                                text: "error code " + res.status
                            })
                        }

                    })
                }
            })
            }

        }

    </script>
</body>

</html>