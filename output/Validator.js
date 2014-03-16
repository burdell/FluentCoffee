// Generated by CoffeeScript 1.7.1
var ObjectValidation, Validation, Validator,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Validator = (function() {
  var GetValidation, validationErrors;

  function Validator() {}

  validationErrors = [];

  GetValidation = function(type, itemToValidate) {
    if ("Object") {
      return new ObjectValidation(itemToValidate, validationErrors, this.For);
    }
  };

  Validator.prototype.For = function(type, itemToValidate) {
    var validation;
    return validation = new GetValidation(type, itemToValidate);
  };

  return Validator;

})();

Validation = (function() {
  Validation.currentField = null;

  Validation.currentValue = null;

  function Validation(itemToValidate, validationErrors, KillFunction) {
    this.itemToValidate = itemToValidate;
    this.validationErrors = validationErrors;
    this.KillFunction = KillFunction;
  }

  Validation.prototype.AddError = function(errorMessage) {
    return this.validationErrors.push({
      field: this.currentField,
      message: errorMessage
    });
  };

  Validation.prototype.Validate = function(valid, message) {
    if ((this.currentValue != null) && !valid) {
      return this.AddError("" + this.currentField + " " + message);
    }
  };

  Validation.prototype.For = function(type, itemToValidate) {
    return this.KillFunction(type, itemToValidate);
  };

  Validation.prototype.GreaterThan = function(compareValue) {
    this.Validate(this.currentValue > compareValue, "must be greater than " + compareValue);
    return this;
  };

  Validation.prototype.LessThan = function(compareValue) {
    this.Validate(this.currentValue < compareValue, "must be less than " + compareValue);
    return this;
  };

  Validation.prototype.Between = function(floor, ceiling) {
    this.Validate(this.currentValue > floor && this.currentValue < ceiling, "must be between " + floor + " and " + ceiling);
    return this;
  };

  Validation.prototype.EqualTo = function(compareValue) {
    this.Validate(this.currentValue === compareValue, "must be " + compareValue);
    return this;
  };

  Validation.prototype.Contains = function(substring) {
    this.Validate(this.currentValue.indexOf(substring) > -1, "must contain " + substring);
    return this;
  };

  return Validation;

})();

ObjectValidation = (function(_super) {
  __extends(ObjectValidation, _super);

  function ObjectValidation() {
    return ObjectValidation.__super__.constructor.apply(this, arguments);
  }

  ObjectValidation.prototype.CurrentFieldExists = function() {
    return this.itemToValidate[this.currentField] != null;
  };

  ObjectValidation.prototype.SetCurrent = function(fieldName, required) {
    this.currentField = fieldName;
    this.currentValue = null;
    if (this.CurrentFieldExists) {
      return this.currentValue = this.itemToValidate[this.currentField];
    } else if (required) {
      return this.AddError("" + this.currentField + " is required");
    }
  };

  ObjectValidation.prototype.Require = function(fieldName) {
    this.SetCurrent(fieldName, true);
    return this;
  };

  ObjectValidation.prototype.Optional = function(fieldName) {
    this.SetCurrent(fieldName);
    return this;
  };

  return ObjectValidation;

})(Validation);
