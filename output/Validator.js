// Generated by CoffeeScript 1.7.1
var FunctionValidation, ObjectValidation, Validation, Validator, isArray,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

Validator = (function() {
  var GetValidation, validationOptions;

  function Validator() {
    validationOptions.errorList = [];
  }

  GetValidation = function(itemToValidate, itemName) {
    var typeOf;
    typeOf = typeof itemToValidate;
    if (typeOf === "object" && !isArray(itemToValidate) && (itemToValidate != null)) {
      return new ObjectValidation(itemToValidate, validationOptions, itemName);
    }
    if (typeOf === "function") {
      return new FunctionValidation(itemToValidate, validationOptions, itemName);
    }
    return new Validation(itemToValidate, validationOptions, itemName, true);
  };

  validationOptions = {
    newValidation: GetValidation
  };

  Validator.prototype.For = function(itemToValidate, itemName) {
    return GetValidation(itemToValidate, itemName);
  };

  return Validator;

})();

Validation = (function() {
  Validation.currentValue = null;

  Validation.validateLength = false;

  Validation.applyNot = false;

  function Validation(itemToValidate, validationOptions, itemName, isPrimitiveValue) {
    this.itemToValidate = itemToValidate;
    this.itemName = itemName;
    this.isPrimitiveValue = isPrimitiveValue;
    this.For = __bind(this.For, this);
    if (this.isPrimitiveValue) {
      this.currentValue = this.itemToValidate;
    }
    if (!this.itemName) {
      this.itemName = "Value";
    }
    this.validationErrors = validationOptions.errorList;
    this.newValidation = validationOptions.newValidation;
    this.Validate = function(validateFn, message) {
      if ((this.currentValue != null) && !this.valid(validateFn)) {
        this.AddError(this.generateErrorMessage(this.itemName, message));
      }
      this.validateLength = false;
      return this.applyNot = false;
    };
    this.getValidationValue = function() {
      if (this.validateLength) {
        return this.currentValue.length;
      } else {
        return this.currentValue;
      }
    };
    this.valid = function(validateFn) {
      if (this.applyNot) {
        return !validateFn();
      } else {
        return validateFn();
      }
    };
    this.AddError = function(errorMessage) {
      return this.validationErrors.push({
        value: this.itemName,
        message: errorMessage
      });
    };
    this.generateErrorMessage = function(itemName, errorMessage) {
      return (this.validateLength ? "The length of " : "") + ("" + itemName + " must ") + (this.applyNot ? "not " : "") + errorMessage;
    };
  }

  Validation.prototype.For = function(itemToValidate, itemName) {
    return this.newValidation(itemToValidate, itemName);
  };

  Validation.prototype.Assert = function() {
    return {
      valid: this.validationErrors.length === 0,
      errors: this.validationErrors
    };
  };

  Validation.prototype.GreaterThan = function(compareValue) {
    this.Validate(((function(_this) {
      return function() {
        return _this.getValidationValue() > compareValue;
      };
    })(this)), "be greater than " + compareValue);
    return this;
  };

  Validation.prototype.LessThan = function(compareValue) {
    this.Validate(((function(_this) {
      return function() {
        return _this.getValidationValue() < compareValue;
      };
    })(this)), "be less than " + compareValue);
    return this;
  };

  Validation.prototype.Between = function(floor, ceiling) {
    this.Validate(((function(_this) {
      return function() {
        return _this.getValidationValue() > floor && _this.currentValue < ceiling;
      };
    })(this)), "be between " + floor + " and " + ceiling);
    return this;
  };

  Validation.prototype.EqualTo = function(compareValue) {
    this.Validate(((function(_this) {
      return function() {
        return _this.getValidationValue() === compareValue;
      };
    })(this)), "be " + compareValue);
    return this;
  };

  Validation.prototype.Contains = function(testItem) {
    this.Validate(((function(_this) {
      return function() {
        return _this.currentValue.indexOf(testItem) > -1;
      };
    })(this)), "contain " + testItem);
    return this;
  };

  Validation.prototype.Length = function() {
    this.validateLength = true;
    return this;
  };

  Validation.prototype.Not = function() {
    this.applyNot = true;
    return this;
  };

  return Validation;

})();

ObjectValidation = (function(_super) {
  __extends(ObjectValidation, _super);

  function ObjectValidation() {
    return ObjectValidation.__super__.constructor.apply(this, arguments);
  }

  ObjectValidation.prototype.itemOptionExists = function() {
    var item;
    item = this.itemToValidate[this.itemName];
    return item !== null && item !== void 0;
  };

  ObjectValidation.prototype.SetCurrent = function(fieldName, required) {
    this.itemName = fieldName;
    this.currentValue = null;
    if (this.itemOptionExists()) {
      return this.currentValue = this.itemToValidate[this.itemName];
    } else if (required) {
      return this.AddError("" + this.itemName + " is required");
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

FunctionValidation = (function(_super) {
  __extends(FunctionValidation, _super);

  function FunctionValidation() {
    return FunctionValidation.__super__.constructor.apply(this, arguments);
  }

  FunctionValidation.prototype.WithParameters = function() {
    var itemToValidate, parameters, result, resultValidation;
    parameters = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    itemToValidate = this.validatingFunction || this.itemToValidate;
    result = itemToValidate.apply(null, parameters);
    resultValidation = this.newValidation(result);
    if (typeof result !== 'function') {

    }
    resultValidation.WithParameters = this.WithParameters;
    resultValidation.validatingFunction = this.itemToValidate;
    return resultValidation;
  };

  return FunctionValidation;

})(Validation);

isArray = function(item) {
  if (Array.isArray) {
    return Array.isArray(item);
  } else {
    return toString.call(item === '[object Array]');
  }
};
